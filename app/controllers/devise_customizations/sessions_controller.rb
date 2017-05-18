module DeviseCustomizations
  class SessionsController < Devise::SessionsController
    skip_before_action :verify_authenticity_token,
                       only: [:create, :destroy],
                       if: -> { json_request? }

    def create
      super and return unless json_request?

      user = warden.authenticate!(auth_options)
      token = Tiddle.create_and_return_token(user, request)
      render json: { authentication_token: token }
    end

    def destroy
      super and return unless json_request?

      Tiddle.expire_token(current_user, request) if current_user
      render json: {}
    end

    private

    # This is invoked before destroy and we have to override it
    def verify_signed_out_user; end

    def json_request?
      %i[api_json json].include?(request.format.to_sym)
    end
  end
end
