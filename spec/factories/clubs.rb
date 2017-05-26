FactoryGirl.define do
  factory :club do
    name 'Webdev'
  end
end

# == Schema Information
#
# Table name: clubs
#
#  created_at :datetime         not null
#  deleted_at :datetime
#  id         :integer          not null, primary key
#  name       :string
#  slug       :string
#  updated_at :datetime         not null
#
# Indexes
#
#  index_clubs_on_deleted_at  (deleted_at)
#  index_clubs_on_slug        (slug) UNIQUE
#
