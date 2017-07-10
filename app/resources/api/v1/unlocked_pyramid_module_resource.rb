module Api
  module V1
    class UnlockedPyramidModuleResource < JSONAPI::Resource
      attributes :user_id,
                 :pyramid_module_id,
                 :completed_phases,
                 :days_since_last_confidence_rating,
                 :percent_complete

      belongs_to :user
      belongs_to :pyramid_module

      def days_since_last_confidence_rating
        @model
          .user
          .days_since_last_confidence_rating_for_pyramid_module(
            @model.pyramid_module,
          )
      end

      def percent_complete
        @model.pyramid_module.percent_complete_for_user(@model.user).to_f * 100.0
      end
    end
  end
end
