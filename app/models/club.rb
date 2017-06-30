class Club < ApplicationRecord
  acts_as_paranoid

  extend FriendlyId
  friendly_id :name

  mount_uploader :logo, ImageUploader

  has_many :teams, -> { order(position: :asc) }, dependent: :destroy
  has_many :players, through: :teams

  has_many :subscriptions, -> { order(end_date: :desc) }, dependent: :destroy

  accepts_nested_attributes_for :subscriptions

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
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_clubs_on_deleted_at  (deleted_at)
#  index_clubs_on_slug        (slug) UNIQUE
#
