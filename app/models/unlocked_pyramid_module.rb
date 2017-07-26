class UnlockedPyramidModule < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :pyramid_module

  def display_completed_phases
    completed_phases.join(', ')
  end
end

# == Schema Information
#
# Table name: unlocked_pyramid_modules
#
#  completed_phases  :text             default([]), is an Array
#  created_at        :datetime         not null
#  deleted_at        :datetime
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
