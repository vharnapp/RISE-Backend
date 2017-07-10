class Team < ApplicationRecord
  acts_as_paranoid

  extend FriendlyId
  friendly_id :name

  mount_uploader :logo, ImageUploader

  before_create :generate_code

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

  has_many :enrollments, dependent: :destroy
  has_many :subscriptions, through: :enrollments

  validates :name, presence: true

  def display_code
    # chunk into groups of 3 separated by dashes
    code.chars.to_a.each_slice(3).to_a.map(&:join).join('-')
  end

  def logo_image_url
    if logo.url.present? && !logo.url.match?(/\/assets\/fallback\/default.*/)
      logo.url
    else
      club.logo.url
    end
  end

  before_save do
    self.code = self[:code].delete('-') if self[:code].present?
  end

  private

  def generate_code
    return if self[:code].present?

    loop do
      code = SecureRandom.hex.upcase[1..6]
      next unless code.match?(/[A-Z]/) && code.match?(/[0-9]/) # letters & num
      self.code = code
      break unless Team.exists?(code: code)
    end
  end
end

# == Schema Information
#
# Table name: teams
#
#  club_id     :integer
#  code        :string
#  created_at  :datetime         not null
#  deleted_at  :datetime
#  id          :integer          not null, primary key
#  logo        :string
#  name        :string
#  num_players :integer
#  position    :integer
#  slug        :string
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_teams_on_deleted_at  (deleted_at)
#  index_teams_on_slug        (slug) UNIQUE
#
