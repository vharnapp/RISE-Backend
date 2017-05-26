class Workout < ApplicationRecord
  acts_as_paranoid

  belongs_to :phase

  has_many :exercise_workouts, inverse_of: :workout, dependent: :destroy
  has_many :exercises, through: :exercise_workouts

  accepts_nested_attributes_for :exercises
  accepts_nested_attributes_for :exercise_workouts, allow_destroy: true

  validates :name, presence: true

  delegate :pyramid_module_name, to: :phase
end

# == Schema Information
#
# Table name: workouts
#
#  created_at :datetime         not null
#  deleted_at :datetime
#  id         :integer          not null, primary key
#  name       :string
#  phase_id   :integer
#  updated_at :datetime         not null
#
# Indexes
#
#  index_workouts_on_deleted_at  (deleted_at)
#  index_workouts_on_phase_id    (phase_id)
#
