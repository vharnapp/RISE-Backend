module Api
  module V1
    class PyramidModuleResource < JSONAPI::Resource
      attributes :name,
                 :description,
                 :display_track,
                 :tracks,
                 :keyframe,
                 :video

      has_many :phases
    end
  end
end
