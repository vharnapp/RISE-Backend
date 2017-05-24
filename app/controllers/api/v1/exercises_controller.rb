module Api
  module V1
    class ExercisesController < BaseApiController
      load_and_authorize_resource

      def index
        jsonapi_render json: @exercises
      end

      def show
        jsonapi_render json: @exercise
      end
    end
  end
end
