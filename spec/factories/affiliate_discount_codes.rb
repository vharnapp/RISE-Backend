FactoryGirl.define do
  factory :affiliate_discount_code do
  	
  end
end

# == Schema Information
#
# Table name: affiliate_discount_codes
#
#  affiliation_rate :integer          default(0), not null
#  club_id          :integer
#  code             :string           default("code123"), not null
#  contact_email    :string           default(""), not null
#  contact_name     :string           default(""), not null
#  created_at       :datetime         not null
#  discount         :integer          default(0), not null
#  discount_type    :string           default("amount"), not null
#  end_date         :date
#  id               :integer          not null, primary key
#  max_users        :integer          default(1), not null
#  payment_info     :string           default(""), not null
#  start_date       :date
#  team_id          :integer
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_affiliate_discount_codes_on_club_id  (club_id)
#  index_affiliate_discount_codes_on_team_id  (team_id)
#
