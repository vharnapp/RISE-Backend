module Api
  module V1
    class UserResource < JSONAPI::Resource
      attributes :first_name,
                 :last_name,
                 :full_name,
                 :created_at,
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

      has_many :archieved_user_payments
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

      def archieved_user_payments
        if @model.archieved_user_payments.present?
          archieved_user_payments = @model.archieved_user_payments
        else
          archieved_user_payments = SinglePayment.where(price: 0).first
        end

        archieved_user_payments.map do |archieved_user_payment|
          {
            id: archieved_user_payment.id,
            payment_name: archieved_user_payment.payment_name,
            payment_price: archieved_user_payment.payment_price,
            string_id: archieved_user_payment.payment_name.parameterize,
          }
        end
      end

      def active_subscription
        @model.active_subscription?
      end
    end
  end
end
