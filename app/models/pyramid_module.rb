class PyramidModule < ApplicationRecord
  acts_as_paranoid
  acts_as_list scope: [:level]

  include HasAttachedVideo

  enum display_track: {
    speed: 0,
    skill: 1,
    strength: 2,
  }

  # FIXME: (2017-05-30) jon => Having the order on the association caused AR to
  # trip a validation in the context of accepts_nested_attributes_for :phases
  #
  # has_many :phases, -> { order(position: :asc) }, dependent: :destroy
  has_many :phases, dependent: :destroy
  accepts_nested_attributes_for :phases, allow_destroy: true

  has_many :unlocked_pyramid_modules, dependent: :destroy

  validates :name, :description, :display_track, presence: true

  # Multi-select sends through an empty string for the include_blank option.
  # This removes that.
  before_validation do |model|
    model.tracks&.reject!(&:blank?)
  end

  def prerequisites
    PyramidModule.where(id: prereq).map(&:name).join(', ')
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
