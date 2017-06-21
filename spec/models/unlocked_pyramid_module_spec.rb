require 'rails_helper'

RSpec.describe UnlockedPyramidModule, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: unlocked_pyramid_modules
#
#  completed_phases  :text             default([]), is an Array
#  created_at        :datetime         not null
#  id                :integer          not null, primary key
#  pyramid_module_id :integer
#  updated_at        :datetime         not null
#  user_id           :integer
#
# Indexes
#
#  index_unlocked_pyramid_modules_on_pyramid_module_id  (pyramid_module_id)
#  index_unlocked_pyramid_modules_on_user_id            (user_id)
#
