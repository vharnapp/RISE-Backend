module Api
  module V1
    class ExerciseWorkoutResource < JSONAPI::Resource
      has_one :exercise
      has_one :workout
    end
  end
end
