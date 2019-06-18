# rubocop:disable Metrics/ClassLength
class User < ApplicationRecord
  acts_as_paranoid

  extend FriendlyId
  friendly_id :full_name

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :token_authenticatable

  before_create :generate_uuid

  # Permissions cascade/inherit through the roles listed below. The order of
  # this list is important, it should progress from least to most privelage
  ROLES = [:player, :coach, :club_admin, :admin].freeze
  acts_as_user roles: ROLES
  roles ROLES

  has_many :authentication_tokens, dependent: :destroy

  has_many :affiliations, dependent: :destroy
  has_many :teams, through: :affiliations
  has_many :subscriptions, through: :teams
  has_one :subscription, dependent: :destroy # individual sign up
  has_one :single_payment 
  has_many :archieved_user_payments, dependent: :destroy
  has_many :clubs, through: :teams

  has_many :coach_affiliations, -> { coaches }, class_name: 'Affiliation'
  has_many :player_affiliations, -> { players }, class_name: 'Affiliation'

  has_many :teams_coached,
           through: :coach_affiliations,
           class_name: 'Team',
           source: :team
  has_many :teams_played,
           through: :player_affiliations,
           class_name: 'Team',
           source: :team

  has_many :clubs_coached,
           through: :teams_coached,
           class_name: 'Club',
           source: :club
  has_many :clubs_played,
           through: :teams_played,
           class_name: 'Club',
           source: :club

  has_many :club_affiliations, dependent: :destroy
  has_many :clubs_administered,
           through: :club_affiliations,
           source: :club

  has_many :confidence_ratings, dependent: :destroy
  has_many :exercises, through: :confidence_ratings
  has_many :workouts, through: :confidence_ratings
  has_many :phases, through: :workouts
  has_many :pyramid_modules, -> { distinct }, through: :phases

  has_many :unlocked_pyramid_modules, dependent: :destroy
  has_many :available_pyramid_modules,
           through: :unlocked_pyramid_modules,
           class_name: 'PyramidModule',
           source: :pyramid_module

  has_many :phase_attempts, dependent: :destroy
  has_many :attempted_phases, through: :phase_attempts, source: :phase

  mount_uploader :avatar, AvatarUploader

  validates :email,
            presence: true,
            format: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,8}\z/i,
            uniqueness: true

  # NOTE: these password validations won't run if the user has an invite token
  validates :password,
            presence: true,
            length: { within: 8..72 },
            confirmation: true,
            on: :create
  validates :password_confirmation,
            presence: true,
            on: :create
  validates :first_name, :last_name, presence: true

  def tester?
    (email =~ /(example.com|headway.io)$/).present?
  end

  def invitation_not_accepted?
    invitation_token != nil && invitation_accepted_at == nil
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def role_list
    roles.map(&:to_s).map(&:titleize).sort.join(', ')
  end

  def active_today?
    count =
      confidence_ratings
        .where('updated_at >= ?', Time.current.beginning_of_day)
        .count

    count.positive?
  end

  def day_streak
    conf_ratings =
      confidence_ratings
        .order(updated_at: :desc)
        .select(:updated_at)
        .map(&:updated_at)
        .map(&:to_date)
        .uniq

    streak = 0
    conf_ratings.map.with_index do |cr, index|
      index += 1 if conf_ratings.first == 1.day.ago.to_date

      break unless cr == index.days.ago.to_date
      streak += 1
    end
    streak
  end

  # TODO: (2017-07-12) jon => move this to pyramid module? or move percent_complete_for_user to here.
  def days_since_last_confidence_rating_for_pyramid_module(pyramid_module)
    workout_ids = pyramid_module.phases.includes(:workouts).uniq.flat_map(&:workouts).map(&:id)

    if confidence_ratings
      crs = confidence_ratings.where(workout: workout_ids).order(updated_at: :desc).limit(1)
      if crs.present?
        ((Time.current - crs.first.updated_at) / 1.day).round
      else
        'x'
      end
    else
      'x'
    end
  end

  def week_view
    ratings = confidence_ratings
      .includes(workout: { phase: :pyramid_module })
      .where('confidence_ratings.updated_at > ?', 7.days.ago)
      .order('confidence_ratings.updated_at')
      .uniq
      .each_with_object({}) do |wk, memo|
        memo[wk.updated_at.to_date.to_s(:db)] = wk.workout.phase.pyramid_module.id
      end

    (6.days.ago.to_date..Time.current.to_date).map do |date|
      { date.to_s(:db) => ratings.fetch(date.to_s(:db), nil) }
      # { date.to_s(:short).split(' ').reverse => ratings.fetch(date.to_s(:db), nil) }
    end
  end

  def skills_mastered
    confidence_ratings
      .joins(workout: :phase)
      .where(
        rating: 4,
        workouts: { supplemental: false, phases: { supplemental: false } },
      )
      .count
  end

  def highest_pyramid_level_achieved
    pyramid_modules.where('level < ?', 5).select(:level).order(level: :desc).limit(1).first.level
  rescue
    1
  end

  def unlock_starting_pyramid_modules
    PyramidModule.default_unlocked.each do |pm|
      unlocked_pyramid_modules.create!(pyramid_module: pm)
    end

    unlocked_pyramid_modules.includes(:pyramid_module)
  end

  def active_subscription?
    if self.single_payment_id.nil?
      subscriptions.merge(Subscription.current).present? || (subscription&.current? == true)
    else
      payment = SinglePayment.where(id: self.single_payment_id).first
      payment.price > 0
    end
  end

  def get_single_payment
    SinglePayment.where(id: self.single_payment_id).first
  end

  def has_archieved_user_payment(single_payment_id)
    ArchievedUserPayment.where(user_id: self.id).where(single_payment_id: single_payment_id).exists?
  end

  def subscription_expires_on
    return nil if subscriptions.blank? && subscription.blank?
    subscription_ids = subscriptions.pluck(:id)
    subscription_ids = subscription_ids + [subscription.id] if subscription.present?
    Subscription.where(id: subscription_ids).select(:end_date).order(end_date: :desc).limit(1).first.end_date
  end

  def analytics_identify(timestamp: nil, traits: {})
    return if tester?

    address = try(:address)
    address_attrs = {}
    address_attrs.merge!(
      city: (address.city rescue 'unknown'),
      postal_code: (address.zip rescue 'unknown'),
      state: (address.state.name rescue 'unknown'),
      street: ("#{address.line1} #{address.line2}" rescue 'unknown'),
    ) if address.present?

    identify_hash = {
      user_id: uuid,
      traits: {
        email: email,
        first_name: first_name,
        last_name: last_name,
        address: address_attrs.to_json,
        created_at: created_at.iso8601,
        last_sign_in_at: (last_sign_in_at.iso8601 rescue ''),
        current_sign_in_at: (current_sign_in_at.iso8601 rescue ''),
        roles: role_list,
        active_sub: active_subscription?.to_s,
        sub_exp_at: (subscription_expires_on.iso8601 rescue ''),
        day_streak: day_streak.to_s,
        skills_mastered: skills_mastered.to_s,
        highest_pyramid_level: highest_pyramid_level_achieved.to_s,
        teams: teams.map(&:name).join(', '),
        clubs: clubs.map(&:name).join(', '),
      }.merge(traits),
    }

    if timestamp.present?
      if timestamp == 'import'
        timestamp = (last_sign_in_at rescue Time.zone.now)
      end

      identify_hash.merge!(
        timestamp: timestamp,
      )
    end

    Analytics.identify(identify_hash)
  end

  private

  def generate_uuid
    loop do
      uuid = SecureRandom.uuid
      self.uuid = uuid
      break unless User.exists?(uuid: uuid)
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  avatar                 :string
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  deleted_at             :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  id                     :integer          not null, primary key
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_id          :integer
#  invited_by_type        :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  nickname               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  roles_mask             :integer
#  sign_in_count          :integer          default(0), not null
#  single_payment_id      :integer
#  slug                   :string
#  stripe_customer_id     :string
#  stripe_payment_id      :string
#  updated_at             :datetime         not null
#  uuid                   :string
#
# Indexes
#
#  index_users_on_deleted_at                         (deleted_at)
#  index_users_on_email                              (email) UNIQUE
#  index_users_on_invitation_token                   (invitation_token) UNIQUE
#  index_users_on_invitations_count                  (invitations_count)
#  index_users_on_invited_by_id                      (invited_by_id)
#  index_users_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_users_on_reset_password_token               (reset_password_token) UNIQUE
#  index_users_on_slug                               (slug) UNIQUE
#
