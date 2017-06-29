module Api
  module V1
    class AffiliationsController < BaseApiController
      authorize_resource

      # rubocop:disable Metrics/MethodLength
      def create
        team = Team.find_by(code: params[:data][:attributes][:team_code])

        if team.present?
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
    end
  end
end
