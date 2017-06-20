module Api
  module V1
    class UnlockedPyramidModuleResource < JSONAPI::Resource
      attributes :user_id,
                 :pyramid_module_id,
                 :completed_phases,
                 :days_since_last_confidence_rating

      belongs_to :user
      belongs_to :pyramid_module

      def days_since_last_confidence_rating
        @model
          .user
          .days_since_last_confidence_rating_for_pyramid_module(
            @model.pyramid_module,
          )
      end
    end
  end
end
