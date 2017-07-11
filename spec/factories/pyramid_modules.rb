FactoryGirl.define do
  factory :pyramid_module do
    name { Faker::Name.pyramid_module_name }
    display_track { %w[speed skill strength].sample }

    callback(:after_build, :after_stub, :after_create) do |model|
      model.description = "Description for: #{model.name}"
      model.save
    end
  end
end

# == Schema Information
#
# Table name: pyramid_modules
#
#  created_at            :datetime         not null
#  deleted_at            :datetime
#  description           :text
#  display_track         :integer
#  icon                  :string
#  id                    :integer          not null, primary key
#  keyframe_content_type :string
#  keyframe_file_name    :string
#  keyframe_file_size    :integer
#  keyframe_updated_at   :datetime
#  level                 :integer
#  name                  :string
#  position              :integer
#  prereq                :text             default([]), is an Array
#  tracks                :text             default([]), is an Array
#  updated_at            :datetime         not null
#  video_content_type    :string
#  video_file_name       :string
#  video_file_size       :integer
#  video_updated_at      :datetime
#
# Indexes
#
#  index_pyramid_modules_on_deleted_at  (deleted_at)
#
