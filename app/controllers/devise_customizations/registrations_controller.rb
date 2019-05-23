module DeviseCustomizations
  class RegistrationsController < Devise::RegistrationsController
    def create
      free_payment = SinglePayment.where(price: 0).first
      build_resource(sign_up_params)
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

        redirect_to new_user_registration_path(
          plan: params[:plan_type],
          anon_id: params[:anon_id],
          first_name: resource.first_name,
          last_name: resource.last_name,
          email: resource.email,
        )
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
