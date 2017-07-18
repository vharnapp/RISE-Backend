module Api
  module V1
    class AffiliationResource < JSONAPI::Resource
      attributes :user_id,
                 :team_id,
                 :team_code,
                 :coach

      has_one :user
      has_one :team

      filters :user_id, :team_id, :coach

      def fetchable_fields
        super - [:team_code]
      end
    end
  end
end
