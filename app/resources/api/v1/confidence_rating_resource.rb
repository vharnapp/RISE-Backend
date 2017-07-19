module Api
  module V1
    class ConfidenceRatingResource < JSONAPI::Resource
      attributes :rating,
                 :skipped,
                 :user_id,
                 :exercise_id,
                 :workout_id

      has_one :user
      has_one :exercise
      has_one :workout

      filters :exercise_id, :workout_id
    end
  end
end
