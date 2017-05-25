class Workout < ApplicationRecord
  belongs_to :phase

  has_many :exercise_workouts, dependent: :destroy
  has_many :exercises, through: :exercise_workouts

  accepts_nested_attributes_for :exercises, allow_destroy: true

  validates :name, presence: true

  delegate :pyramid_module_name, to: :phase
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
