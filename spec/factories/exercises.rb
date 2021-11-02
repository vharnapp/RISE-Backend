FactoryGirl.define do
  factory :exercise do
    name "MyString"
    description "MyText"
    sets 1
    reps 1
    rest "MyString"
  end
end

# == Schema Information
#
# Table name: exercises
#
#  created_at            :datetime         not null
#  deleted_at            :datetime
#  description           :text
#  id                    :integer          not null, primary key
#  keyframe_content_type :string
#  keyframe_file_name    :string
#  keyframe_file_size    :integer
#  keyframe_updated_at   :datetime
#  name                  :string
#  reps                  :string
#  rest                  :string
#  sets                  :string
#  updated_at            :datetime         not null
#  video_content_type    :string
#  video_file_name       :string
#  video_file_size       :integer
#  video_updated_at      :datetime
#
# Indexes
#
#  index_exercises_on_deleted_at  (deleted_at)
#
