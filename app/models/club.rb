class Club < ApplicationRecord
  acts_as_paranoid

  extend FriendlyId
  friendly_id :name

  mount_uploader :logo, ImageUploader
  mount_uploader :teams_csv, ImageUploader # prob make a file uploader

  has_many :temp_teams
  has_many :teams, -> { order(position: :asc) }, dependent: :destroy
  has_many :players, through: :teams

  has_many :subscriptions, -> { order(end_date: :desc) }, inverse_of: :club, dependent: :destroy

  accepts_nested_attributes_for :subscriptions, allow_destroy: true
  accepts_nested_attributes_for :temp_teams

  validates :name, presence: true

  def fee
    subscriptions.current.first.price * subscriptions.current.first.players.count
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
#
# Indexes
#
#  index_clubs_on_deleted_at  (deleted_at)
#  index_clubs_on_slug        (slug) UNIQUE
#
