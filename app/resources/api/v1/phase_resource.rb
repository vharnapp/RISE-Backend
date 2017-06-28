module Api
  module V1
    class PhaseResource < JSONAPI::Resource
      include KeyframeFields

      attributes :name,
                 :position,
                 :supplemental,
                 :video

      belongs_to :pyramid_module
      has_many :workouts

      has_many :phase_attempts
      has_many :users, through: :phase_attempts
    end
  end
end
