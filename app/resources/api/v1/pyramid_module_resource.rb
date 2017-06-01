module Api
  module V1
    class PyramidModuleResource < JSONAPI::Resource
      attributes :name,
                 :description,
                 :level,
                 :prereq,
                 :position,
                 :display_track,
                 :tracks,
                 :keyframe,
                 :video

      has_many :phases
    end
  end
end
