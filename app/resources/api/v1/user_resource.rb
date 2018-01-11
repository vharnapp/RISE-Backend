module Api
  module V1
    class UserResource < JSONAPI::Resource
      attributes :first_name,
                 :last_name,
                 :full_name,
                 :nickname,
                 :email,
                 :avatar,
                 :password,
                 :password_confirmation,
                 :active_subscription,
                 :subscription_expires_on,
                 :skills_mastered,
                 :day_streak,
                 :week_view,
                 :phase_attempts,
                 :teams

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

      def teams
        if @model.teams.present?
          teams = @model.teams
        else
          # TODO: (2018-01-10) jon => add this team somewhere as seed data for
          # the environments. This is on production as of 1/10/2018. I manually
          # created it.
          teams = Team.where(name: 'RISE')
        end

        teams.map do |team|
          {
            id: team.id,
            name: team.name,
            logo_image_url: team.logo_image_url,
          }
        end
      end

      def active_subscription
        @model.active_subscription?
      end
    end
  end
end
