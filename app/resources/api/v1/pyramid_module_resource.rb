module Api
  module V1
    class PyramidModuleResource < JSONAPI::Resource
      include KeyframeFields

      attributes :name,
                 :icon, # legacy, remove this after Jason fixed the back end
                 :icon_white,
                 :icon_black,
                 :description,
                 :level,
                 :prereq,
                 :display_track,
                 :tracks,
                 :video,
                 :position

      has_many :phases

      # FIXME: (2017-06-02) jon => This isn't working, not 100% sure why
      # def self.default_sort
      #   [{ field: :position, direction: :asc }]
      # end

      def icon
        icon_white
      end
    end
  end
end
