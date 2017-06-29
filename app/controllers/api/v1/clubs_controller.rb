module Api
  module V1
    class ClubsController < BaseApiController
      load_and_authorize_resource

      def index
        jsonapi_render json: @clubs
      end

      def show
        jsonapi_render json: @club
      end

      def create
        club = Club.new(resource_params)

        if club.save
          jsonapi_render json: club, status: :created
        else
          jsonapi_render_errors json: club,
                                status: :unprocessable_entity
        end
      end

      def update
        if @club.update(resource_params)
          jsonapi_render json: @club, status: :ok
        else
          jsonapi_render_errors json: @club,
                                status: :unprocessable_entity
        end
      end
    end
  end
end
