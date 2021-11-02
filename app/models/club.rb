class Club < ApplicationRecord
  acts_as_paranoid

  extend FriendlyId
  friendly_id :name

  mount_uploader :logo, LogoUploader
  mount_uploader :teams_csv, FileUploader

  has_many :temp_teams, dependent: :destroy
  has_many :teams, -> { order(position: :asc) }, dependent: :destroy
  has_many :coaches, through: :teams
  has_many :players, through: :teams

  has_many :club_affiliations
  has_many :administrators,
           through: :club_affiliations,
           class_name: 'User',
           source: :user

  has_many :subscriptions, -> { order(end_date: :desc) }, inverse_of: :club, dependent: :destroy

  accepts_nested_attributes_for :subscriptions, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :temp_teams, reject_if: :all_blank

  validates :name, presence: true

  def my_teams(user)
    if user.admin? || user.club_admin?
      teams.order(:name)
    else
      teams.merge(user.teams_coached).order(:name)
    end
  end

  def display_address
    output = ''
    output << "#{address_line1}<br>"
    output << "#{address_line2}<br>" if address_line2.present?
    output << "#{address_city}, #{address_state} #{address_zip}"
    output.html_safe
  end

  def fee
    subscriptions.current.first.price * subscriptions.current.first.players.count
  end

  def invited_coaches
    coaches.merge(User.invitation_not_accepted)
  end

  def display_invited_coaches
    invited_coaches.map do |coach|
      "#{coach.full_name.ljust(30)} - #{coach.email}"
    end.join("\n").html_safe
  end
end

# == Schema Information
#
# Table name: clubs
#
#  address_city       :string
#  address_line1      :string
#  address_line2      :string
#  address_state      :string
#  address_zip        :string
#  contact_email      :string
#  contact_first_name :string
#  contact_last_name  :string
#  contact_phone      :string
#  created_at         :datetime         not null
#  deleted_at         :datetime
#  id                 :integer          not null, primary key
#  logo               :string
#  name               :string
#  position           :integer
#  slug               :string
#  teams_csv          :string
#  updated_at         :datetime         not null
#  welcome_message    :text
#
# Indexes
#
#  index_clubs_on_deleted_at  (deleted_at)
#  index_clubs_on_slug        (slug) UNIQUE
#
