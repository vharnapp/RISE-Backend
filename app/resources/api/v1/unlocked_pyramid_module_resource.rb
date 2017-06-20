module Api
  module V1
    class UnlockedPyramidModuleResource < JSONAPI::Resource
      attributes :user_id,
                 :pyramid_module_id,
                 :completed_phases

      belongs_to :user
      belongs_to :pyramid_module
    end
  end
end
