FactoryGirl.define do
  factory :temp_team do
    name "MyString"
    num_players 1
    coach_first_name "MyString"
    coach_last_name "MyString"
    coach_email "MyString"
  end
end

# == Schema Information
#
# Table name: temp_teams
#
#  club_id          :integer
#  coach_email      :string
#  coach_first_name :string
#  coach_last_name  :string
#  created_at       :datetime         not null
#  id               :integer          not null, primary key
#  name             :string
#  num_players      :integer
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_temp_teams_on_club_id  (club_id)
#
