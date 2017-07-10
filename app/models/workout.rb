class Workout < ApplicationRecord
  acts_as_paranoid
  acts_as_list scope: :phase

  belongs_to :phase, inverse_of: :workouts

  has_many :exercise_workouts,
           -> { order(position: :asc) },
           inverse_of: :workout,
           dependent: :destroy
  has_many :exercises, through: :exercise_workouts

  has_many :confidence_ratings, dependent: :destroy
  has_many :users, through: :confidence_ratings
  has_many :rated_exercises, through: :confidence_ratings, class_name: 'Exercise', source: :exercise

  accepts_nested_attributes_for :exercises
  accepts_nested_attributes_for :exercise_workouts, allow_destroy: true

  validates :name, presence: true

  delegate :pyramid_module_name, to: :phase
end

# == Schema Information
#
# Table name: workouts
#
#  created_at   :datetime         not null
#  deleted_at   :datetime
#  id           :integer          not null, primary key
#  name         :string
#  phase_id     :integer
#  position     :integer
#  supplemental :boolean          default(FALSE)
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_workouts_on_deleted_at  (deleted_at)
#  index_workouts_on_phase_id    (phase_id)
#
