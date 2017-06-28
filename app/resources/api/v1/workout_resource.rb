module Api
  module V1
    class WorkoutResource < JSONAPI::Resource
      attributes :name,
                 :supplemental,
                 :exercises

      belongs_to :phase

      has_many :exercise_workouts
      has_many :exercises, through: :exercise_workouts

      has_many :confidence_ratings
      has_many :users, through: :confidence_ratings
      has_many :rated_exercises, through: :confidence_ratings, class_name: 'Exercise', source: :exercise

      def exercises
        @model.exercise_workouts.map do |exercise_workout|
          exercise = exercise_workout.exercise

          {
            type: 'exercises',
            id: exercise.id,
            name: exercise.name,
            description: exercise.description,
            sets: exercise.sets,
            reps: exercise.reps,
            rest: exercise.rest,
            keyframe: exercise.keyframe,
            keyframe_medium: exercise.keyframe.url(:medium),
            keyframe_thumb: exercise.keyframe.url(:thumb),
            video: exercise.video,
            position: exercise_workout.position,
          }
        end
      end
    end
  end
end
