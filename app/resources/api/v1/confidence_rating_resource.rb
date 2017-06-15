module Api
  module V1
    class ConfidenceRatingResource < JSONAPI::Resource
      attributes :rating,
                 :skipped,
                 :user_id,
                 :exercise_id,
                 :workout_id

      belongs_to :user
      belongs_to :exercise
      belongs_to :workout
    end
  end
end
