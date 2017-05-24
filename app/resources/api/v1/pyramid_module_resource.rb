module Api
  module V1
    class PyramidModuleResource < JSONAPI::Resource
      attributes :name, :description, :track, :keyframe, :video

      has_many :phases
    end
  end
end
