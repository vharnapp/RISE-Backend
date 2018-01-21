module Api
  module V1
    class ConfidenceRatingsController < BaseApiController
      load_and_authorize_resource

      def index
        json =
          current_user
            .confidence_ratings
            .joins(:workout)

        jsonapi_render json: json
      end

      def create
        confidence_rating = ConfidenceRating.new(resource_params)
        confidence_rating.user = current_user

        if confidence_rating.save
          analytics_track(current_user, 'Created Confidence Rating', { exercise_name: confidence_rating.exercise.name })
          jsonapi_render json: confidence_rating, status: :created
        else
          jsonapi_render_errors json: confidence_rating,
                                status: :unprocessable_entity
        end
      end

      def update
        if @confidence_rating.update(resource_params)
          analytics_track(current_user, 'Updated Confidence Rating', { exercise_name: confidence_rating.exercise.name })
          jsonapi_render json: @confidence_rating, status: :ok
        else
          jsonapi_render_errors json: @confidence_rating,
                                status: :unprocessable_entity
        end
      end
    end
  end
end
