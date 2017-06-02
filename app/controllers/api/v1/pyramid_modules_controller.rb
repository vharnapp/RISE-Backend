module Api
  module V1
    class PyramidModulesController < BaseApiController
      before_action :find_pyramid_module, only: :show
      load_resource only: :index
      authorize_resource

      def index
        @pyramid_modules =
          @pyramid_modules
            .includes(phases: { workouts: { exercise_workouts: :exercise } })

        jsonapi_render json: @pyramid_modules
      end

      def show
        jsonapi_render json: @pyramid_module
      end

      private

      def find_pyramid_module
        @pyramid_module =
          PyramidModule
            .includes(phases: { workouts: { exercise_workouts: :exercise } })
            .find(params[:id])
      end
    end
  end
end
