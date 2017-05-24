module HasAttachedVideo
  extend ActiveSupport::Concern

  included do
    has_attached_file :keyframe,
                      styles: {
                        medium: '300x300>',
                        thumb: '100x100>',
                      }
    validates_attachment_content_type :keyframe, content_type: %r{\Aimage\/.*\z}

    has_attached_file :video,
                      styles: {
                        mp4video: {
                          geometry: '520x390',
                          format: 'mp4',
                          # convert_options: {
                          #   output: {
                          #     vcodec: 'libx264',
                          #     vpre: 'ipod640',
                          #     b: '250k',
                          #     bt: '50k',
                          #     acodec: 'libfaac',
                          #     ab: '56k',
                          #     ac: 2,
                          #   },
                          # },
                        },
                        preview: {
                          geometry: '300x300>',
                          format: 'jpg',
                          time: 5,
                        },
                      },
                      processors: [:transcoder],
                      size: { in: 0..50.megabytes }

    validates_attachment_content_type :video, content_type: %r{\Avideo\/.*\Z}
    validates :keyframe, presence: true
  end
end
