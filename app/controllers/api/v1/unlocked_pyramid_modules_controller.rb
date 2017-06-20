module Api
  module V1
    class UnlockedPyramidModulesController < BaseApiController
      before_action :find_user, only: :index
      load_resource only: :index
      authorize_resource

      def index
        jsonapi_render json: @user.unlocked_pyramid_modules
      end

      private

      def find_user
        @user = User.find(params[:user_id])
      end
    end
  end
end
