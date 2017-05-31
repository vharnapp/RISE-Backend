class Phase < ApplicationRecord
  # FIXME: (2017-05-30) jon => Having the order on the association in the
  # PyramidModule class caused AR to trip a validation in the context of
  # accepts_nested_attributes_for :phases. So instead, add a default scope here
  # so that PyramidModule.first.phases properly includes that order sql statement
  default_scope { order(position: :asc) }

  include HasAttachedVideo

  acts_as_paranoid
  acts_as_list scope: :pyramid_module

  belongs_to :pyramid_module
  has_many :workouts, -> { order(position: :asc) }, dependent: :destroy

  accepts_nested_attributes_for :workouts, allow_destroy: true

  validates :name, presence: true

  def pyramid_module_name
    pyramid_module.name
  end
end

# == Schema Information
#
# Table name: phases
#
#  created_at            :datetime         not null
#  deleted_at            :datetime
#  id                    :integer          not null, primary key
#  keyframe_content_type :string
#  keyframe_file_name    :string
#  keyframe_file_size    :integer
#  keyframe_updated_at   :datetime
#  name                  :string
#  position              :integer
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
#  index_phases_on_deleted_at         (deleted_at)
#  index_phases_on_pyramid_module_id  (pyramid_module_id)
#
