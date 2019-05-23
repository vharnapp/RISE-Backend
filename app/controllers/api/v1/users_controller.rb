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
        analytics_track(current_user, 'Show User', { user_db_id: @user.id, showing_self: current_user.id == @user.id })
        jsonapi_render json: @user
      end

      def create
        free_payment = SinglePayment.where(price: 0).first
        @user = User.new(user_params)
        @user.roles << :player
        @user.single_payment_id = free_payment.id

        if @user.save

          free_payment.pyramid_modules.each do |pyramid_module|
            if UnlockedPyramidModule.where(pyramid_module_id: pyramid_module.id).where(user_id: @user.id).empty? 
              UnlockedPyramidModule.create(pyramid_module_id: pyramid_module.id, user_id: @user.id)
            end
          end

          @user.analytics_identify(traits: { sign_up_source: 'App' })

          # On successful creation, generate token and return in response
          render_json_user_with_token(@user, return_user: false)
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
