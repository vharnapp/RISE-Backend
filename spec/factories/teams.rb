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
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string
#  updated_at :datetime         not null
#
