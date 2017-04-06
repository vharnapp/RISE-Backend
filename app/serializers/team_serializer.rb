class TeamSerializer < ActiveModel::Serializer
  attributes :id, :name
end

# == Schema Information
#
# Table name: teams
#
#  club_id    :integer
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string
#  slug       :string
#  updated_at :datetime         not null
#
# Indexes
#
#  index_teams_on_slug  (slug) UNIQUE
#
