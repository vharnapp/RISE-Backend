class PyramidModule < ApplicationRecord
  enum track: {
    speed: 0,
    skill: 1,
    strength: 2,
  }

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
  validates :name, :description, :track, :keyframe, presence: true
end

# == Schema Information
#
# Table name: pyramid_modules
#
#  created_at            :datetime         not null
#  description           :text
#  id                    :integer          not null, primary key
#  keyframe_content_type :string
#  keyframe_file_name    :string
#  keyframe_file_size    :integer
#  keyframe_updated_at   :datetime
#  name                  :string
#  track                 :integer
#  updated_at            :datetime         not null
#  video_content_type    :string
#  video_file_name       :string
#  video_file_size       :integer
#  video_updated_at      :datetime
#
