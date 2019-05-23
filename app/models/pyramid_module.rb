class PyramidModule < ApplicationRecord
  acts_as_paranoid
  acts_as_list scope: [:level]

  include HasAttachedVideo
  mount_uploader :icon_white, PyramidModuleIconUploader
  mount_uploader :icon_black, PyramidModuleIconUploader

  enum display_track: {
    speed: 0,
    skill: 1,
    strength: 2,
  }

  scope :by_level, (->(level) { where(level: level).order(:position) })

  has_and_belongs_to_many :single_payments

  has_many :phases,
           -> { order(position: :asc) },
           inverse_of: :pyramid_module,
           dependent: :destroy

  accepts_nested_attributes_for :phases, allow_destroy: true

  has_many :workouts, through: :phases

  has_many :unlocked_pyramid_modules, dependent: :destroy
  has_many :users, through: :unlocked_pyramid_modules

  validates :name, :description, :display_track, presence: true

  # Multi-select sends through an empty string for the include_blank option.
  # This removes that.
  before_validation do |model|
    model.tracks&.reject!(&:blank?)
  end

  def self.default_unlocked
    where(position: [1, 2, 3, 4, 5])
  end

  def prerequisites
    PyramidModule.where(id: prereq).map(&:name).join(', ')
  end

  def percent_complete_for_user(user, debug: false)
    num_skills_mastered =
      user
        .confidence_ratings
        .joins(workout: :phase)
        .where(confidence_ratings: { rating: 4 })
        .where(workout: workouts)
        .where(phases: { supplemental: false })
        .count

    num_exercises =
      workouts
        .includes(:exercises)
        .where(phases: { supplemental: false })
        .uniq
        .flat_map(&:exercises)
        .count

    percent = (num_skills_mastered.to_d / num_exercises.to_d).round(2)

    if debug
      return %(
        <br>mastered: #{num_skills_mastered}
        <br>num: #{num_exercises}
        <br>percent: #{percent}
      ).html_safe
    end

    if num_exercises.to_i.positive?
      return 1.0 if percent > 1.0 # in case a user has more confidence ratings than exercises accidentally somhow
      percent
    else
      0.0
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
