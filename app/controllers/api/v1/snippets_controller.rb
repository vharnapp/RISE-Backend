module Api
  module V1
    class SnippetsController < BaseApiController
      load_resource
      skip_authorization_check
      skip_before_action :authenticate_user!

      def show
        jsonapi_render json: @snippet
      end
    end
  end
end
