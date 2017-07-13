# rubocop:disable Metrics/ClassLength
class User < ApplicationRecord
  acts_as_paranoid

  extend FriendlyId
  friendly_id :full_name

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :token_authenticatable

  before_create :generate_uuid

  # Permissions cascade/inherit through the roles listed below. The order of
  # this list is important, it should progress from least to most privelage
  ROLES = [:player, :coach, :club_admin, :admin].freeze
  acts_as_user roles: ROLES
  roles ROLES

  has_many :authentication_tokens, dependent: :destroy

  has_many :affiliations, dependent: :destroy
  has_many :teams, through: :affiliations
  has_many :clubs, through: :teams

  has_many :club_affiliations
  has_many :administered_clubs,
           through: :club_affiliations,
           source: :club

  has_many :confidence_ratings, dependent: :destroy
  has_many :exercises, through: :confidence_ratings
  has_many :workouts, through: :confidence_ratings
  has_many :phases, through: :workouts
  has_many :pyramid_modules, -> { distinct }, through: :phases

  has_many :unlocked_pyramid_modules, dependent: :destroy

  has_many :phase_attempts, dependent: :destroy
  has_many :attempted_phases, through: :phase_attempts, source: :phase

  mount_uploader :avatar, ImageUploader

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

  # rubocop:disable Metrics/MethodLength
  def day_streak
    sql = %(
      WITH RECURSIVE CTE(updated_at)
      AS (
        SELECT MAX(date(updated_at))
        FROM confidence_ratings
        WHERE user_id = #{id}

        UNION ALL

        SELECT date(a.updated_at)
        FROM confidence_ratings a
        INNER JOIN CTE c
        ON date(a.updated_at) = date(c.updated_at) - INTERVAL '1 day'
        WHERE a.user_id = #{id}
      )
      SELECT DISTINCT * FROM CTE ORDER BY updated_at DESC;
    ).squish

    streak_days = ActiveRecord::Base.connection.execute(sql).values.flatten

    if streak_days.count == 1 && streak_days.first.nil?
      0
    elsif Date.parse(streak_days.first) < 1.day.ago.to_date
      0
    else
      streak_days.count
    end
  end
  # rubocop:enable Metrics/MethodLength

  # TODO: (2017-07-12) jon => move this to pyramid module? or move percent_complete_for_user to here.
  def days_since_last_confidence_rating_for_pyramid_module(pyramid_module)
    workout_ids = pyramid_module.phases.includes(:workouts).flat_map(&:workouts).map(&:id)

    if confidence_ratings
      crs = confidence_ratings.where(workout: workout_ids).order(:updated_at)
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
      .includes(:workout)
      .where(rating: 4, workouts: { supplemental: false })
      .count
  end

  def highest_pyramid_level_achieved
    pyramid_modules.select(:level).order(level: :desc).limit(1).first.level
  rescue
    1
  end

  def unlock_starting_pyramid_module
    pm = PyramidModule.default_unlocked
    unlocked_pyramid_modules.create(pyramid_module: pm)
    unlocked_pyramid_modules
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
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  nickname               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  roles_mask             :integer
#  sign_in_count          :integer          default(0), not null
#  slug                   :string
#  updated_at             :datetime         not null
#  uuid                   :string
#
# Indexes
#
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#
