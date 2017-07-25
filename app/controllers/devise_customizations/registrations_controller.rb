module DeviseCustomizations
  class RegistrationsController < Devise::RegistrationsController
    def create
      super
    end

    protected

    def after_sign_up_path_for(resource)
      analytics_alias_user_path(resource)
    end

    def update_resource(resource, params)
      resource.update_without_password(params)
    end
  end
end
