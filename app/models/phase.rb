class Phase < ApplicationRecord
  belongs_to :pyramid_module
  has_many :workouts

  accepts_nested_attributes_for :workouts
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
