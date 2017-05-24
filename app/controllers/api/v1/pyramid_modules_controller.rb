module Api
  module V1
    class PyramidModulesController < BaseApiController
      load_and_authorize_resource

      def index
        jsonapi_render json: @pyramid_modules
      end

      def show
        jsonapi_render json: @pyramid_module
      end
    end
  end
end
