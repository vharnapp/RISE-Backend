class ExerciseWorkout < ApplicationRecord
  acts_as_paranoid

  belongs_to :exercise
  belongs_to :workout

  accepts_nested_attributes_for :exercise, reject_if: :all_blank
end

# == Schema Information
#
# Table name: exercise_workouts
#
#  created_at  :datetime         not null
#  deleted_at  :datetime
#  exercise_id :integer
#  id          :integer          not null, primary key
#  updated_at  :datetime         not null
#  workout_id  :integer
#
# Indexes
#
#  index_exercise_workouts_on_deleted_at   (deleted_at)
#  index_exercise_workouts_on_exercise_id  (exercise_id)
#  index_exercise_workouts_on_workout_id   (workout_id)
#
