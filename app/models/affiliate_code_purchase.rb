class AffiliateCodePurchase < ApplicationRecord
	belongs_to :affiliate_discount_code 
	belongs_to :club 
	belongs_to :user 
end

# == Schema Information
#
# Table name: affiliate_code_purchases

#
#  affiliate_discount_code_id   :integer
#  affiliate_revenue            :float            default(0), not null
#  club_id                      :integer
#  created_at                   :datetime         not null
#  discount                     :float            default(0), not null
#  discounted_price             :float            default(0), not null
#  full_price                   :float            default(0), not null
#  id                           :integer          not null, primary key
#  program_name                 :string           default(""), not null
#  updated_at                   :datetime         not null
#  user_id                      :integer
#
# Indexes
#  index_affiliate_discount_codes_on_affiliate_discount_code_id  (affiliate_discount_code_id)
#  index_affiliate_discount_codes_on_club_id  (club_id)
#  index_affiliate_discount_codes_on_user_id  (team_id)
#
