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

  has_many :confidence_ratings, dependent: :destroy
  has_many :exercises, through: :confidence_ratings
  has_many :workouts, through: :confidence_ratings

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

  # rubocop:disable Metrics/MethodLength
  def day_streak
    sql = %(
      WITH RECURSIVE CTE(updated_at)
      AS
      (
        SELECT * FROM
        (
            SELECT date(updated_at)
            FROM confidence_ratings
            WHERE user_id = '#{id}'
              AND (
                date(updated_at) = current_date
                OR date(updated_at) = current_date - INTERVAL '1 day'
              )
            ORDER BY date(updated_at) DESC
            LIMIT 1
        ) tab
        UNION ALL

        SELECT date(a.updated_at)
        FROM confidence_ratings a
          INNER JOIN CTE c
          ON date(a.updated_at) = date(c.updated_at) - INTERVAL '1 day'
          WHERE user_id = '#{id}'
      )
      SELECT COUNT(*) FROM CTE;
    ).squish
    ActiveRecord::Base.connection.execute(sql).getvalue(0, 0)
  end
  # rubocop:enable Metrics/MethodLength

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
#  created_at               :datetime         not null
#  current_sign_in_at       :datetime
#  current_sign_in_ip       :inet
#  deleted_at               :datetime
#  email                    :string           default(""), not null
#  encrypted_password       :string           default(""), not null
#  first_name               :string
#  id                       :integer          not null, primary key
#  last_name                :string
#  last_sign_in_at          :datetime
#  last_sign_in_ip          :inet
#  nickname                 :string
#  remember_created_at      :datetime
#  reset_password_sent_at   :datetime
#  reset_password_token     :string
#  roles_mask               :integer
#  sign_in_count            :integer          default(0), not null
#  slug                     :string
#  unlocked_pyramid_modules :text             default([]), is an Array
#  updated_at               :datetime         not null
#  uuid                     :string
#
# Indexes
#
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#
