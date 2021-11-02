FactoryGirl.define do
  factory :workout do
    name { Faker::Name.workout_name }
    phase
  end
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
