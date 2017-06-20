module Api
  module V1
    class UnlockedPyramidModulesController < BaseApiController
      before_action :find_user
      load_and_authorize_resource

      def index
        jsonapi_render json: @user.unlocked_pyramid_modules
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

      private

      def find_user
        @user = User.find(params[:user_id])
      end
    end
  end
end
