module Api
  module V1
    class ExerciseResource < JSONAPI::Resource
      include KeyframeFields

      attributes :name,
                 :description,
                 :sets,
                 :reps,
                 :rest,
                 :video

      has_many :exercise_workouts
      has_many :workouts, through: :exercise_workouts

      has_many :confidence_ratings
      has_many :users, through: :confidence_ratings
      has_many :rated_workouts, through: :confidence_ratings, class_name: 'Workout', source: :workout
    end
  end
end
