module Api
  module V1
    class UserResource < JSONAPI::Resource
      attributes :first_name,
                 :last_name,
                 :full_name,
                 :email,
                 :password,
                 :password_confirmation

      def fetchable_fields
        super - [:password, :password_confirmation]
      end
    end
  end
end
