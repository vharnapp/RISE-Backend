module Api
  module V1
    class AffiliationsController < BaseApiController
      authorize_resource

      # rubocop:disable Metrics/MethodLength
      def create
        code = params[:data][:attributes][:team_code].delete('-')
        team = Team.find_by('LOWER(code) = ?', code.downcase)

        if team.present? && team.players.count.to_i >= team.num_players.to_i
          render json: {
            errors: [
              {
                status: '422',
                title: 'Unprocessable entity',
                detail: "Team is full. #{team.num_players} players max.",
              },
            ],
          }, status: :unprocessable_entity
        elsif team.present?
          affiliation =
            Affiliation.new(team_id: team.id, user_id: current_user.id)
            current_user.update_column(:single_payment_id, nil)
            UnlockedPyramidModule.where(user_id: current_user.id).update(has_restriction: 0)

            unlock_pyramid_module_values = Array.new
            pyramid_modules = PyramidModule.select("id,name").where(id: [3,5,7,8,9,10,11,12,13,15,16,17]).order(:id)
            today = Date.today
            pyramid_modules.each do |pyramid_module|
              if UnlockedPyramidModule.where(pyramid_module_id: pyramid_module.id).where(user_id: current_user.id).empty? 
                unlock_pyramid_module_values << "(#{current_user.id},#{pyramid_module.id},'{}','#{today} 00:00:00','#{today} 00:00:00')"
              end
            end

            if (unlock_pyramid_module_values.count > 0 && team.id == 149)
              unlock_complete_training_modules_sql = "INSERT INTO unlocked_pyramid_modules (user_id, pyramid_module_id, completed_phases, created_at, updated_at) VALUES #{unlock_pyramid_module_values.join(',')};"
              ActiveRecord::Base.connection.execute(unlock_complete_training_modules_sql)
            end

          if affiliation.save
            jsonapi_render json: affiliation, status: :created
          else
            jsonapi_render_errors json: affiliation,
                                  status: :unprocessable_entity
          end
        else
          render json: {
            errors: [
              {
                status: '422',
                title: 'Unprocessable entity',
                detail: 'Team code is invalid.',
              },
            ],
          }, status: :unprocessable_entity
        end
      end
      # rubocop:enable Metrics/MethodLength

      def destroy
        team = Team.find_by(id: params[:team_id])

        if team.present?
          affiliation =
            Affiliation.find_by(team_id: team.id, user_id: params[:user_id])

          if affiliation.destroy
            jsonapi_render status: :ok
          else
            jsonapi_render_errors json: affiliation,
                                  status: :unprocessable_entity
          end
        else
          render json: {
            errors: [
              {
                status: '422',
                title: 'Unprocessable entity',
                detail: 'Team not found.',
              },
            ],
          }, status: :unprocessable_entity
        end
      end
    end
  end
end
