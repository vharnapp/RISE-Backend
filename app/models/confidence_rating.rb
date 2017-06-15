class ConfidenceRating < ApplicationRecord
  belongs_to :user
  belongs_to :exercise
  belongs_to :workout
end

# == Schema Information
#
# Table name: confidence_ratings
#
#  created_at  :datetime         not null
#  exercise_id :integer
#  id          :integer          not null, primary key
#  rating      :integer          default(0)
#  skipped     :boolean          default(FALSE), not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  workout_id  :integer
#
# Indexes
#
#  index_confidence_ratings_on_exercise_id  (exercise_id)
#  index_confidence_ratings_on_user_id      (user_id)
#  index_confidence_ratings_on_workout_id   (workout_id)
#
