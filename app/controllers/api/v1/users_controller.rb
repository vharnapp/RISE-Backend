module Api
  module V1
    class UsersController < BaseApiController
      include RenderJsonUserWithToken

      load_and_authorize_resource(except: :create)
      skip_authorization_check(only: :create)
      skip_before_action :authenticate_user!, only: :create

      def index
        jsonapi_render json: User.all
      end

      def show
        jsonapi_render json: @user
      end

      def create
        @user = User.new(user_params)
        @user.roles << :player

        if @user.save
          @user.unlock_starting_pyramid_modules

          # On successful creation, generate token and return in response
          render_json_user_with_token(@user)
        else
          jsonapi_render_errors json: @user, status: :unprocessable_entity
        end
      end

      def update
        if @user.update_attributes(user_params)
          jsonapi_render json: @user, status: :ok
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
