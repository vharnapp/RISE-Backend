module Api
  module V1
    class ArchievedUserPaymentsController < BaseApiController
      load_and_authorize_resource

      def index
        json =
          current_user
            .archieved_user_payments

        jsonapi_render json: json
      end

      def create
      end

      def update
      end
    end
  end
end
