module HasAttachedVideo
  extend ActiveSupport::Concern

  included do
    has_attached_file :keyframe,
                      default_url: 'public/images/missing_keyframe.png',
                      styles: {
                        medium: '300x300>',
                        thumb: '100x100>',
                      }
    validates_attachment_content_type :keyframe, content_type: %r{\Aimage\/.*\z}

    has_attached_file :video
    # has_attached_file :video,
                      # styles: {
                        # mp4video: {
                          # geometry: '1920x1080',
                          # format: 'mp4',
                        # },
                        # preview: {
                          # geometry: '1920x1080>',
                          # format: 'jpg',
                          # time: 0,
                        # },
                      # },
                      # processors: [:transcoder],
                      # size: { in: 0..50.megabytes }

    validates_attachment_content_type :video, content_type: %r{\Avideo\/.*\Z}
  end
end
