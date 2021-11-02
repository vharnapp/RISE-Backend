module Api
  module V1
    class ClubResource < JSONAPI::Resource
      attributes :name,
                 :welcome_message,
                 :logo,
                 :logo_thumb

      has_many :teams

      def logo_thumb
        logo.thumb.url
      end
    end
  end
end
