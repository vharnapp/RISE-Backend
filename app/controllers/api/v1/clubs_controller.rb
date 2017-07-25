module Api
  module V1
    class ClubsController < BaseApiController
      load_and_authorize_resource

      def index
        jsonapi_render json: current_user.clubs
      end

      def show
        jsonapi_render json: @club
      end
    end
  end
end
