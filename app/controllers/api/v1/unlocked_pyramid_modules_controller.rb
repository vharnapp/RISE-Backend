module Api
  module V1
    class UnlockedPyramidModulesController < BaseApiController
      load_and_authorize_resource

      def index
        
        # Check if the user is member of a team
        # If yes, loads all his pyramid modules
        # If Not, loads only the purhased ones, or the starter modules if he didn't purchased any of them
        if current_user.subscriptions.merge(Subscription.current).present? || (current_user.subscription&.current? == true)
          unlocked_pyramid_modules = current_user.unlocked_pyramid_modules.includes(:pyramid_module)
        else 
          pyramid_module_ids = PyramidModule.default_unlocked.pluck(:id)
          single_payment_ids = current_user.archieved_user_payments.pluck(:single_payment_id)
          
          if single_payment_ids.count > 0
            single_payments = SinglePayment.where(id: single_payment_ids)
            single_payments.each do |item|
              pyramid_module_ids = pyramid_module_ids + item.pyramid_modules.pluck(:id)
            end
          end

          unlocked_pyramid_modules = current_user.unlocked_pyramid_modules.where(pyramid_module_id: pyramid_module_ids).includes(:pyramid_module)
        end

        #if unlocked_pyramid_modules.blank? || (unlocked_pyramid_modules.present? && unlocked_pyramid_modules.map(&:pyramid_module_id) == [PyramidModule.find_by(level: 5).id])
        #  unlocked_pyramid_modules =
        #    current_user.unlock_starting_pyramid_modules
        #end

        if unlocked_pyramid_modules.blank?
          unlocked_pyramid_modules =
            current_user.unlock_starting_pyramid_modules
        end

        jsonapi_render json: unlocked_pyramid_modules
      end

      def create
        unlocked_pyramid_module = UnlockedPyramidModule.new(resource_params)
        unlocked_pyramid_module.user = current_user

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
