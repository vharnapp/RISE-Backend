FactoryGirl.define do
  factory :affiliation do
    user nil
    team nil
    coach false
  end
end

# == Schema Information
#
# Table name: affiliations
#
#  coach      :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  team_id    :integer
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_affiliations_on_team_id  (team_id)
#  index_affiliations_on_user_id  (user_id)
#
