module KeyframeFields
  extend ActiveSupport::Concern

  included do
    attributes :keyframe,
               :keyframe_medium,
               :keyframe_thumb

    def keyframe_medium
      keyframe.url(:medium)
    end

    def keyframe_thumb
      keyframe.url(:thumb)
    end
  end
end
