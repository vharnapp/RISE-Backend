require 'rails_helper'

RSpec.describe Workout, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: workouts
#
#  created_at :datetime         not null
#  deleted_at :datetime
#  id         :integer          not null, primary key
#  level      :integer
#  name       :string
#  phase_id   :integer
#  position   :integer
#  prereq     :text             default([]), is an Array
#  updated_at :datetime         not null
#
# Indexes
#
#  index_workouts_on_deleted_at  (deleted_at)
#  index_workouts_on_phase_id    (phase_id)
#
