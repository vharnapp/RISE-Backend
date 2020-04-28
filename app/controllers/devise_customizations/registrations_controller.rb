module DeviseCustomizations
  class RegistrationsController < Devise::RegistrationsController
    def create
      free_payment = SinglePayment.where(price: 0).first
      build_resource(sign_up_params)
      
      if resource.email.present?
        aux_user = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM users where email='#{resource.email}'")

        if aux_user.count > 0
          session[:reg_plan] = params[:plan_type]
          session[:reg_anon_id] = params[:anon_id]
          session[:reg_first_name] = sign_up_params[:first_name]
          session[:reg_last_name] = sign_up_params[:last_name]
          session[:reg_email] = sign_up_params[:email]
          session[:reg_email_error] = "User with this email already exists"

          return redirect_to new_user_registration_path
        end
      end

      resource.roles << :player
      resource.single_payment_id = free_payment.id
      resource.save
      yield resource if block_given?

      if resource.persisted?
        free_payment.pyramid_modules.each do |pyramid_module|
          if UnlockedPyramidModule.where(pyramid_module_id: pyramid_module.id).where(user_id: resource.id).empty? 
            UnlockedPyramidModule.create(pyramid_module_id: pyramid_module.id, user_id: resource.id, has_restriction: 1)
          end
        end
        
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length

        respond_with resource if json_request?

        session[:reg_plan] = params[:plan_type]
        session[:reg_anon_id] = params[:anon_id]
        session[:reg_first_name] = resource.first_name
        session[:reg_last_name] = resource.last_name
        session[:reg_email] = resource.email

        if resource.errors[:first_name].present?
          session[:reg_first_name_error] = "First name #{resource.errors[:first_name][0]}"
        end
        if resource.errors[:last_name].present?
          session[:reg_last_name_error] = "Last name #{resource.errors[:last_name][0]}"
        end
        if resource.errors[:email].present?
          session[:reg_email_error] = "Email #{resource.errors[:email][0]}"
        end
        if resource.errors[:password].present?
          session[:reg_password_error] = "Password #{resource.errors[:password][0]}"
        end
        if resource.errors[:password_confirmation].present?
          session[:reg_password_confirmation_error] = "Password confirmation #{resource.errors[:password_confirmation][0]}"
        end

        redirect_to new_user_registration_path
      end
    end

    def edit
      gon.persist_flash = true
      super
    end

    private

    def json_request?
      %i[api_json json].include?(request.format.to_sym)
    end

    protected

    def after_sign_up_path_for(resource)
      analytics_alias_user_path(resource, plan_type: params[:plan_type], anon_id: params[:anon_id])
    end

    def update_resource(resource, params)
      resource.update_without_password(params)
    end
  end
end
