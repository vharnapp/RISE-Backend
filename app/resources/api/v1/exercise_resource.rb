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
    end
  end
end
