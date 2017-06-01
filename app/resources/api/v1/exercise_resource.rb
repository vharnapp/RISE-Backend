module Api
  module V1
    class ExerciseResource < JSONAPI::Resource
      attributes :name,
                 :description,
                 :sets,
                 :reps,
                 :rest,
                 :keyframe,
                 :video

      has_many :exercise_workouts
      has_many :workouts, through: :exercise_workouts
    end
  end
end
