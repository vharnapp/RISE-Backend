FactoryGirl.define do
  factory :archieved_user_payment do
    
  end
end

# == Schema Information
#
# Table name: archieved_user_payments
#
#  created_at        :datetime         not null
#  id                :integer          not null, primary key
#  payment_name      :string
#  payment_price     :float
#  payment_stripe_id :string
#  single_payment_id :integer
#  updated_at        :datetime         not null
#  user_id           :integer
#
# Indexes
#
#  index_archieved_user_payments_on_single_payment_id  (single_payment_id)
#  index_archieved_user_payments_on_user_id            (user_id)
#
