module Api
  module V1
    class ClubResource < JSONAPI::Resource
      attributes :name,
                 :logo

      has_many :teams
    end
  end
end
