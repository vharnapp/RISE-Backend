module HasAttachedVideo
  extend ActiveSupport::Concern

  included do
    has_attached_file :keyframe,
                      default_url: "//s3-us-west-2.amazonaws.com/rise-media2/missing_#{self.name.underscore.pluralize}/:style/missing_keyframe.png",
                      preserve_files: true,
                      styles: {
                        medium: '480x',
                        thumb: '100x',
                      }
    validates_attachment_content_type :keyframe, content_type: %r{\Aimage\/.*\z}

    has_attached_file :video, preserve_files: true
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
