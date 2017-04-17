FactoryGirl.define do
  factory :authentication_token do
    body 'asdfjkl123'
    ip_address '127.0.0.1'
    user_agent 'RSpec'
  end
end

# == Schema Information
#
# Table name: authentication_tokens
#
#  body         :string
#  created_at   :datetime         not null
#  id           :integer          not null, primary key
#  ip_address   :string
#  last_used_at :datetime
#  updated_at   :datetime         not null
#  user_agent   :string
#  user_id      :integer
#
# Indexes
#
#  index_authentication_tokens_on_user_id  (user_id)
#
