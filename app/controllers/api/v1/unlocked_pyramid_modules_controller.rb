module Api
  module V1
    class UnlockedPyramidModulesController < BaseApiController
      load_and_authorize_resource

      def index
        unlocked_pyramid_modules =
          current_user.unlocked_pyramid_modules.includes(:pyramid_module)

        if unlocked_pyramid_modules.blank?
          unlocked_pyramid_modules = PyramidModule.default_unlocked
        end

        jsonapi_render json: unlocked_pyramid_modules
      end

      def create
        unlocked_pyramid_module = UnlockedPyramidModule.new(resource_params)

        if unlocked_pyramid_module.save
          jsonapi_render json: unlocked_pyramid_module, status: :created
        else
          jsonapi_render_errors json: unlocked_pyramid_module,
                                status: :unprocessable_entity
        end
      end

      def update
        if @unlocked_pyramid_module.update(resource_params)
          jsonapi_render json: @unlocked_pyramid_module, status: :ok
        else
          jsonapi_render_errors json: @unlocked_pyramid_module,
                                status: :unprocessable_entity
        end
      end
    end
  end
end
