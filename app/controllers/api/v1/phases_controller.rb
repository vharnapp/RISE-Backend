module Api
  module V1
    class PhasesController < BaseApiController
      load_and_authorize_resource :pyramid_module
      load_and_authorize_resource :phase, through: :pyramid_module

      def index
        jsonapi_render json: @phases
      end

      def show
        jsonapi_render json: @phase
      end
    end
  end
end
