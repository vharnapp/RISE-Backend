module DeviseCustomizations
  class SessionsController < Devise::SessionsController
    include RenderJsonUserWithToken

    skip_before_action :verify_authenticity_token,
                       only: [:create, :destroy],
                       if: -> { json_request? }

    def create
      analytics_track(current_user, 'Sign In')
      super and return unless json_request?

      user = warden.authenticate!(auth_options)
      render_json_user_with_token(user, return_user: true)
    end

    def destroy
      # NOTE: (2018-01-20) jon => we're apparently not actually hitting this from the mobile app
      analytics_track(current_user, 'Sign Out')
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

    protected

    def after_sign_in_path_for(resource)
      stored_location_for(resource) || root_path(plan_type: params[:plan_type])
    end
  end
end
