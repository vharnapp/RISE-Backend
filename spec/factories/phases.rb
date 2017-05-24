FactoryGirl.define do
  factory :phase do
    name "MyString"
  end
end

# == Schema Information
#
# Table name: phases
#
#  created_at        :datetime         not null
#  id                :integer          not null, primary key
#  name              :string
#  pyramid_module_id :integer
#  supplemental      :boolean          default(FALSE), not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_phases_on_pyramid_module_id  (pyramid_module_id)
#
