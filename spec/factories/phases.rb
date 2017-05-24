FactoryGirl.define do
  factory :phase do
    name "MyString"
  end
end

# == Schema Information
#
# Table name: phases
#
#  created_at            :datetime         not null
#  id                    :integer          not null, primary key
#  keyframe_content_type :string
#  keyframe_file_name    :string
#  keyframe_file_size    :integer
#  keyframe_updated_at   :datetime
#  name                  :string
#  pyramid_module_id     :integer
#  supplemental          :boolean          default(FALSE), not null
#  updated_at            :datetime         not null
#  video_content_type    :string
#  video_file_name       :string
#  video_file_size       :integer
#  video_updated_at      :datetime
#
# Indexes
#
#  index_phases_on_pyramid_module_id  (pyramid_module_id)
#
