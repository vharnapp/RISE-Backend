module Api
  module V1
    class TeamsController < BaseApiController
      load_and_authorize_resource :user
      load_and_authorize_resource :team, through: :user

      def index
        jsonapi_render json: @teams
      end

      def show
        jsonapi_render json: @team
      end

      def create
        team = Team.new(resource_params)

        if team.save
          jsonapi_render json: team, status: :created
        else
          jsonapi_render_errors json: team,
                                status: :unprocessable_entity
        end
      end

      def update
        if @team.update(resource_params)
          jsonapi_render json: @team, status: :ok
        else
          jsonapi_render_errors json: @team,
                                status: :unprocessable_entity
        end
      end
    end
  end
end
