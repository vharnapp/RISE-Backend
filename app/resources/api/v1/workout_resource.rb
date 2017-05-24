module Api
  module V1
    class WorkoutResource < JSONAPI::Resource
      attributes :name

      has_many :exercises
    end
  end
end
