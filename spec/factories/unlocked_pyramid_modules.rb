FactoryGirl.define do
  factory :unlocked_pyramid_module do
    user nil
    pyramid_module nil
    completed_phases []
  end
end

# == Schema Information
#
# Table name: unlocked_pyramid_modules
#
#  completed_phases  :text             default([]), is an Array
#  created_at        :datetime         not null
#  deleted_at        :datetime
#  has_restriction   :integer          default(1)
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
