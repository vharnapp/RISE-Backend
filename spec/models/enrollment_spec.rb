require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: enrollments
#
#  created_at      :datetime         not null
#  id              :integer          not null, primary key
#  subscription_id :integer
#  team_id         :integer
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_enrollments_on_subscription_id  (subscription_id)
#  index_enrollments_on_team_id          (team_id)
#
