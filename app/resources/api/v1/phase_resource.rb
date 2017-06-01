module Api
  module V1
    class PhaseResource < JSONAPI::Resource
      attributes :name,
                 :position,
                 :supplemental,
                 :keyframe,
                 :video,
                 :workouts

      belongs_to :pyramid_module
      has_many :workouts
    end
  end
end
