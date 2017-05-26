class Club < ApplicationRecord
  acts_as_paranoid

  extend FriendlyId
  friendly_id :name

  has_many :teams, dependent: :destroy

  validates :name, presence: true
end

# == Schema Information
#
# Table name: clubs
#
#  created_at :datetime         not null
#  deleted_at :datetime
#  id         :integer          not null, primary key
#  level      :integer
#  name       :string
#  position   :integer
#  prereq     :text             default([]), is an Array
#  slug       :string
#  updated_at :datetime         not null
#
# Indexes
#
#  index_clubs_on_deleted_at  (deleted_at)
#  index_clubs_on_slug        (slug) UNIQUE
#
