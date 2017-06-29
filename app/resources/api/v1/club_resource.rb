module Api
  module V1
    class ClubResource < JSONAPI::Resource
      attributes :name

      has_many :teams
    end
  end
end
