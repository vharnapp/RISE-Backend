module Api
  module V1
    class ArchievedUserPaymentResource < JSONAPI::Resource
      attribute :string_id
      attributes :single_payment_id,
                 :payment_name,
                 :user_id,
                 :payment_price,
                 :payment_stripe_id

      has_one :user

      def string_id
        @model.payment_name.parameterize
      end
    end
  end
end
