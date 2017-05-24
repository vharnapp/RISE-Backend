FactoryGirl.define do
  factory :workout do
    name "MyString"
    phase nil
  end
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
