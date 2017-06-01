module Api
  module V1
    class WorkoutResource < JSONAPI::Resource
      attributes :name, :exercises

      belongs_to :phase

      has_many :exercise_workouts
      has_many :exercises, through: :exercise_workouts

      def exercises
        @model.exercise_workouts.map do |exercise_workout|
          exercise = exercise_workout.exercise

          {
            id: exercise.id,
            name: exercise.name,
            description: exercise.name,
            sets: exercise.sets,
            reps: exercise.reps,
            rest: exercise.rest,
            keyframe: exercise.keyframe,
            video: exercise.video,
            position: exercise_workout.position,
          }
        end
      end
    end
  end
end
