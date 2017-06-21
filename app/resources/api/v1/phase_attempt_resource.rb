module Api
  module V1
    class PhaseAttemptResource < JSONAPI::Resource
      attributes :user_id,
                 :phase_id,
                 :count

      belongs_to :user
      belongs_to :phase
    end
  end
end
