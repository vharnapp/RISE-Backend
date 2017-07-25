module Api
  module V1
    class TeamsController < BaseApiController
      load_and_authorize_resource :user
      load_and_authorize_resource :team, through: :user, shallow: true

      def index
        jsonapi_render json: @teams
      end

      def show
        jsonapi_render json: @team
      end
    end
  end
end
