class Team < ApplicationRecord
  belongs_to :club

  has_many :affiliations
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
#  id         :integer          not null, primary key
#  name       :string
#  updated_at :datetime         not null
#
