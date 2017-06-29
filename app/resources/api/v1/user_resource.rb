module Api
  module V1
    class UserResource < JSONAPI::Resource
      attributes :first_name,
                 :last_name,
                 :full_name,
                 :nickname,
                 :email,
                 :password,
                 :password_confirmation,
                 :skills_mastered,
                 :day_streak,
                 :week_view,
                 :phase_attempts,
                 :avatar

      has_many :confidence_ratings
      has_many :exercises, through: :confidence_ratings
      has_many :workouts, through: :confidence_ratings

      has_many :unlocked_pyramid_modules

      has_many :phase_attempts
      has_many :phases, through: :phase_attempts

      has_many :affiliations
      has_many :teams, through: :affiliations

      def fetchable_fields
        super - [:password, :password_confirmation]
      end
    end
  end
end
