FactoryGirl.define do
  factory :subscription do
    start_date { Date.today }
    end_date { 1.year.from_now }
    price '10'
  end
end

# == Schema Information
#
# Table name: subscriptions
#
#  club_id    :integer
#  created_at :datetime         not null
#  end_date   :date
#  id         :integer          not null, primary key
#  price      :decimal(, )
#  start_date :date
#  updated_at :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_club_id  (club_id)
#
