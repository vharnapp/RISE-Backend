require 'rails_helper'

RSpec.describe PyramidModule, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: pyramid_modules
#
#  created_at            :datetime         not null
#  deleted_at            :datetime
#  description           :text
#  display_track         :integer
#  icon_black            :string
#  icon_white            :string
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
