module Api
  module V1
    class PhaseResource < JSONAPI::Resource
      attributes :name,
                 :keyframe,
                 :video

      has_many :workouts
    end
  end
end
