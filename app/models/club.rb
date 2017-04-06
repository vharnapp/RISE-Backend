class Club < ApplicationRecord
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
#  id         :integer          not null, primary key
#  name       :string
#  slug       :string
#  updated_at :datetime         not null
#
# Indexes
#
#  index_clubs_on_slug  (slug) UNIQUE
#
