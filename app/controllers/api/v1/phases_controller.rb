module Api
  module V1
    class PhasesController < BaseApiController
      load_and_authorize_resource

      def index
        jsonapi_render json: @phases
      end

      def show
        jsonapi_render json: @phase
      end
    end
  end
end
