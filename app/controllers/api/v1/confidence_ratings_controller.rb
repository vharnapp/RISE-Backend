module Api
  module V1
    class ConfidenceRatingsController < BaseApiController
      load_and_authorize_resource

      def index
        jsonapi_render json: current_user.confidence_ratings
      end

      def create
        confidence_rating = ConfidenceRating.new(resource_params)

        if confidence_rating.save
          jsonapi_render json: confidence_rating, status: :created
        else
          jsonapi_render_errors json: confidence_rating,
                                status: :unprocessable_entity
        end
      end

      def update
        if @confidence_rating.update(resource_params)
          jsonapi_render json: @confidence_rating, status: :ok
        else
          jsonapi_render_errors json: @confidence_rating,
                                status: :unprocessable_entity
        end
      end
    end
  end
end
