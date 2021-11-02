module Api
  module V1
    class PhaseAttemptResource < JSONAPI::Resource
      attributes :user_id,
                 :phase_id,
                 :count

      has_one :user
      has_one :phase
    end
  end
end
