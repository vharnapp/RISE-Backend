module Api
  module V1
    class PhaseAttemptsController < BaseApiController
      load_and_authorize_resource

      def index
        jsonapi_render json: current_user.phase_attempts
      end

      def create
        phase_attempt = PhaseAttempt.new(resource_params)

        if phase_attempt.save
          jsonapi_render json: phase_attempt, status: :created
        else
          jsonapi_render_errors json: phase_attempt,
                                status: :unprocessable_entity
        end
      end

      def update
        if @phase_attempt.update(resource_params)
          jsonapi_render json: @phase_attempt, status: :ok
        else
          jsonapi_render_errors json: @phase_attempt,
                                status: :unprocessable_entity
        end
      end
    end
  end
end
