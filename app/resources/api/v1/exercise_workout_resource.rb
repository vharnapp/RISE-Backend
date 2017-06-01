module Api
  module V1
    class ExerciseWorkoutResource < JSONAPI::Resource
      belongs_to :exercise
      belongs_to :workout
    end
  end
end
