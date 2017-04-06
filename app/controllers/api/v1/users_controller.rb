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
          respond_with(@user)
        else
          respond_with_errors(@user)
        end
      end

      def destroy
        if @user.destroy
          render json: {}, status: 204
        else
          render json: {}, status: 500
        end
      end

      private

      def user_params
        resource_params
      end
    end
  end
end
