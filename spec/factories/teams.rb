FactoryGirl.define do
  factory :team do
    name 'Headway'
  end
end

# == Schema Information
#
# Table name: teams
#
#  club_id    :integer
#  code       :string
#  created_at :datetime         not null
#  deleted_at :datetime
#  id         :integer          not null, primary key
#  logo       :string
#  name       :string
#  position   :integer
#  slug       :string
#  updated_at :datetime         not null
#
# Indexes
#
#  index_teams_on_deleted_at  (deleted_at)
#  index_teams_on_slug        (slug) UNIQUE
#
