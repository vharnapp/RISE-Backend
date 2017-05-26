class Exercise < ApplicationRecord
  acts_as_paranoid

  include HasAttachedVideo

  has_many :exercise_workouts, inverse_of: :exercise, dependent: :destroy
  has_many :workouts, through: :exercise_workouts

  validates :name,
            :description,
            :sets,
            :reps,
            :rest,
            presence: true
end

# == Schema Information
#
# Table name: exercises
#
#  created_at            :datetime         not null
#  deleted_at            :datetime
#  description           :text
#  id                    :integer          not null, primary key
#  keyframe_content_type :string
#  keyframe_file_name    :string
#  keyframe_file_size    :integer
#  keyframe_updated_at   :datetime
#  name                  :string
#  reps                  :string
#  rest                  :string
#  sets                  :string
#  updated_at            :datetime         not null
#  video_content_type    :string
#  video_file_name       :string
#  video_file_size       :integer
#  video_updated_at      :datetime
#
# Indexes
#
#  index_exercises_on_deleted_at  (deleted_at)
#
