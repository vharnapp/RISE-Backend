class Subscription < ApplicationRecord
  belongs_to :club, inverse_of: :subscriptions

  has_many :enrollments, dependent: :destroy
  has_many :teams, through: :enrollments

  has_many :players, through: :teams

  scope :current, (lambda {
    where('subscriptions.end_date >= ?', Time.current.to_date)
    .where('subscriptions.start_date <= ?', Time.current.to_date)
    .order(end_date: :desc)
  })

  validates :start_date, :end_date, :club, :price, presence: true
  validates :start_date, :end_date, overlap: { scope: 'club_id' }

  validates :start_date, inclusion: {
    in: ->(_subscription) { Time.zone.today..Time.zone.today + 50.years },
    message: 'must be today or further in the future',
  }, on: :create

  validate :end_date_is_after_start_date

  delegate :fee, to: :club, prefix: true

  private

  def end_date_is_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date <= start_date
      errors.add(:end_date, 'must be at least 1 day after the start date')
    end
  end
end

# == Schema Information
#
# Table name: subscriptions
#
#  club_id    :integer
#  created_at :datetime         not null
#  end_date   :date
#  id         :integer          not null, primary key
#  price      :decimal(, )
#  start_date :date
#  updated_at :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_club_id  (club_id)
#
