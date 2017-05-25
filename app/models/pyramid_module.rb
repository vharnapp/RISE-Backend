class PyramidModule < ApplicationRecord
  include HasAttachedVideo

  enum track: {
    speed: 0,
    skill: 1,
    strength: 2,
  }

  has_many :phases

  accepts_nested_attributes_for :phases, allow_destroy: true

  validates :name, :description, :track, presence: true
end

# == Schema Information
#
# Table name: pyramid_modules
#
#  created_at            :datetime         not null
#  description           :text
#  id                    :integer          not null, primary key
#  keyframe_content_type :string
#  keyframe_file_name    :string
#  keyframe_file_size    :integer
#  keyframe_updated_at   :datetime
#  name                  :string
#  track                 :integer
#  updated_at            :datetime         not null
#  video_content_type    :string
#  video_file_name       :string
#  video_file_size       :integer
#  video_updated_at      :datetime
#
