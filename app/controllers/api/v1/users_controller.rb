module Api
  module V1
    class UsersController < BaseApiController
      load_and_authorize_resource

      def index
        jsonapi_render json: User.all
      end

      def show
        jsonapi_render json: @user
      end

      def create
        @user = User.new(user_params)

        if @user.save
          jsonapi_render json: @user, status: :created
        else
          jsonapi_render_errors json: @user, status: :unprocessable_entity
        end
      end

      def update
        if @user.update_attributes(user_params)
          jsonapi_render json: @user, status: :updated
        else
          jsonapi_render_errors json: @user, status: :unprocessable_entity
        end
      end

      def destroy
        @user.destroy
        head :no_content
      end

      private

      def user_params
        resource_params
      end
    end
  end
end
