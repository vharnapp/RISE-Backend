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
                 :unlocked_pyramid_modules

      has_many :confidence_ratings
      has_many :exercises, through: :confidence_ratings
      has_many :workouts, through: :confidence_ratings

      def fetchable_fields
        super - [:password, :password_confirmation]
      end
    end
  end
end
