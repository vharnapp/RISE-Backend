module Api
  module V1
    class WorkoutsController < BaseApiController
      load_and_authorize_resource

      def index
        jsonapi_render json: @workouts
      end

      def show
        jsonapi_render json: @workout
      end
    end
  end
end
