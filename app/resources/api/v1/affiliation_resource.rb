module Api
  module V1
    class AffiliationResource < JSONAPI::Resource
      attributes :user_id,
                 :team_id,
                 :team_code,
                 :coach

      belongs_to :user
      belongs_to :team

      filters :user_id, :team_id, :coach

      def fetchable_fields
        super - [:team_code]
      end
    end
  end
end
