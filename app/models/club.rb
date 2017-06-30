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
#  created_at :datetime         not null
#  deleted_at :datetime
#  id         :integer          not null, primary key
#  logo       :string
#  name       :string
#  position   :integer
#  slug       :string
#  updated_at :datetime         not null
#
# Indexes
#
#  index_clubs_on_deleted_at  (deleted_at)
#  index_clubs_on_slug        (slug) UNIQUE
#
