module Api
  module V1
    class TeamResource < JSONAPI::Resource
      attributes :name,
                 :code

      belongs_to :club
      has_many :affiliations, dependent: :destroy
      has_many :coach_affiliations,  class_name: 'Affiliation'
      has_many :player_affiliations, class_name: 'Affiliation'

      has_many :coaches,
               through: :coach_affiliations,
               class_name: 'User',
               source: :user
      has_many :players,
               through: :player_affiliations,
               class_name: 'User',
               source: :user

      filters :name, :code
    end
  end
end
