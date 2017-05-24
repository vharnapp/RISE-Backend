class Workout < ApplicationRecord
  belongs_to :phase

  has_many :exercise_workouts
  has_many :exercises, through: :exercise_workouts

  validates :name, presence: true

  accepts_nested_attributes_for :exercises
end

# == Schema Information
#
# Table name: workouts
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string
#  phase_id   :integer
#  updated_at :datetime         not null
#
# Indexes
#
#  index_workouts_on_phase_id  (phase_id)
#
