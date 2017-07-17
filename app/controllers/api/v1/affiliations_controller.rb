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
