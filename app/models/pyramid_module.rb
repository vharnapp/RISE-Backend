class PyramidModule < ApplicationRecord
  acts_as_paranoid
  acts_as_list scope: [:level]

  include HasAttachedVideo

  enum track: {
    speed: 0,
    skill: 1,
    strength: 2,
  }

  has_many :phases, -> { order(position: :asc) }, dependent: :destroy

  accepts_nested_attributes_for :phases, allow_destroy: true

  validates :name, :description, :track, presence: true
end

# == Schema Information
#
# Table name: pyramid_modules
#
#  created_at            :datetime         not null
#  deleted_at            :datetime
#  description           :text
#  id                    :integer          not null, primary key
#  keyframe_content_type :string
#  keyframe_file_name    :string
#  keyframe_file_size    :integer
#  keyframe_updated_at   :datetime
#  level                 :integer
#  name                  :string
#  position              :integer
#  prereq                :text             default([]), is an Array
#  track                 :integer
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
