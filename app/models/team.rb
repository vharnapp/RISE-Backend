class Team < ApplicationRecord
  acts_as_paranoid

  extend FriendlyId
  friendly_id :name

  belongs_to :club

  has_many :affiliations, dependent: :destroy
  has_many :coach_affiliations,  -> { coaches }, class_name: 'Affiliation'
  has_many :player_affiliations, -> { players }, class_name: 'Affiliation'

  has_many :coaches,
           through: :coach_affiliations,
           class_name: 'User',
           source: :user
  has_many :players,
           through: :player_affiliations,
           class_name: 'User',
           source: :user

  validates :name, presence: true
end

# == Schema Information
#
# Table name: teams
#
#  club_id    :integer
#  created_at :datetime         not null
#  deleted_at :datetime
#  id         :integer          not null, primary key
#  name       :string
#  slug       :string
#  updated_at :datetime         not null
#
# Indexes
#
#  index_teams_on_deleted_at  (deleted_at)
#  index_teams_on_slug        (slug) UNIQUE
#
