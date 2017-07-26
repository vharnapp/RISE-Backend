module Api
  module V1
    class SnippetsController < BaseApiController
      load_and_authorize_resource

      def show
        jsonapi_render json: @snippet
      end
    end
  end
end
