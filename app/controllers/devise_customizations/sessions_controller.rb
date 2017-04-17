module DeviseCustomizations
  class SessionsController < Devise::SessionsController
    skip_before_action :verify_authenticity_token, only: [:create, :destroy]

    def create
      if request.format == :json
        user = warden.authenticate!(auth_options)
        token = Tiddle.create_and_return_token(user, request)
        render json: { authentication_token: token }
      else
        super
      end
    end

    def destroy
      if request.format == :json
        Tiddle.expire_token(current_user, request) if current_user
        render json: {}
      else
        super
      end
    end

    private

    # This is invoked before destroy and we have to override it
    def verify_signed_out_user; end
  end
end
