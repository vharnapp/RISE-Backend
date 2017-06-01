module Api
  module V1
    class WorkoutResource < JSONAPI::Resource
      attributes :name

      belongs_to :phase
      has_many :exercises
    end
  end
end
