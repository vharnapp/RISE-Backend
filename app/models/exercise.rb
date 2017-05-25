class Exercise < ApplicationRecord
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
#  description           :text
#  id                    :integer          not null, primary key
#  keyframe_content_type :string
#  keyframe_file_name    :string
#  keyframe_file_size    :integer
#  keyframe_updated_at   :datetime
#  name                  :string
#  reps                  :integer
#  rest                  :string
#  sets                  :integer
#  updated_at            :datetime         not null
#  video_content_type    :string
#  video_file_name       :string
#  video_file_size       :integer
#  video_updated_at      :datetime
#
