FactoryGirl.define do
  factory :club_affiliation do
    user nil
    club nil
  end
end

# == Schema Information
#
# Table name: club_affiliations
#
#  club_id    :integer
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_club_affiliations_on_club_id  (club_id)
#  index_club_affiliations_on_user_id  (user_id)
#
