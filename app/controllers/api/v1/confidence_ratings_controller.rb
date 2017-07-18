module Api
  module V1
    class ConfidenceRatingsController < BaseApiController
      load_and_authorize_resource

      def index
        json =
          current_user
            .confidence_ratings
            .includes(workout: { phase: :pyramid_module })

        jsonapi_render json: json
      end

      def create
        confidence_rating = ConfidenceRating.new(resource_params)
        confidence_rating.user = current_user

        if confidence_rating.save
          # jsonapi_render json: confidence_rating, status: :created
          head :ok
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
