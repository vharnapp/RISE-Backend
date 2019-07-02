class Subscription < ApplicationRecord
  include Stripe::Callbacks

  belongs_to :club, optional: true, inverse_of: :subscriptions
  belongs_to :user, optional: true, inverse_of: :subscription

  has_many :enrollments, dependent: :destroy
  has_many :teams, through: :enrollments

  has_many :players, through: :teams

  scope :current, (lambda {
    where('subscriptions.end_date >= ?', Time.current.to_date)
    .where('subscriptions.start_date <= ?', Time.current.to_date)
    .order(end_date: :desc)
  })

  validates :start_date, :end_date, :price, presence: true
  validates :start_date, :end_date, overlap: { scope: 'club_id' }, if: proc { |a| a.club_id.present? }, on: :update
  validates :start_date, :end_date, overlap: { scope: 'user_id' }, if: proc { |a| a.user_id.present? }, on: :update

  validates :start_date, inclusion: {
    in: ->(_subscription) { Time.zone.today..Time.zone.today + 50.years },
    message: 'must be today or further in the future',
  }, on: :create

  validate :end_date_is_after_start_date

  delegate :fee, to: :club, prefix: true

  def current?
    end_date >= Time.current.to_date && start_date <= Time.current.to_date
  end

  def extend_until(new_date, metadata={})
    if created_at.to_date < 1.day.ago
      # we didn't just create the subscription
      update(end_date: new_date)
    end

    update(metadata: metadata)
  end

  private

  after_charge_succeeded! do |charge|
    logger.info charge.inspect
    stripe_customer_id = charge.customer
    stripe_invoice_id = charge.invoice

    if !stripe_customer_id.nil? && !stripe_invoice_id.nil?
      stripe_invoice = Stripe::Invoice.retrieve(stripe_invoice_id)
      stripe_plan_id = stripe_invoice.lines.data.first.plan.id

      new_end_date =
        case stripe_plan_id
        when /monthly.*/
          1.month.from_now
        when /annually.*/
          1.year.from_now
        end

      user = User.find_by(stripe_customer_id: stripe_customer_id)
      subscription = Subscription.find_by(user_id: user.id)

      # NOTE: (2018-07-08) jon => assumes "Central Time (US & Canada)" remains set
      dst_or_not = Time.current.dst? ? 'CDT' : 'CST'
      date_and_time_with_period =
        "#{Time.current.strftime('%m/%d/%Y - %-l:%M %p')} #{dst_or_not}"

      metadata = {
        date_and_time_with_period => { stripe_invoice_id: stripe_invoice_id }
      }

      subscription.extend_until(new_end_date, metadata)
    end
  end

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
#  metadata   :json
#  price      :decimal(, )
#  start_date :date
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_subscriptions_on_club_id  (club_id)
#  index_subscriptions_on_user_id  (user_id)
#
