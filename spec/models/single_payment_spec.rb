require 'rails_helper'

RSpec.describe SinglePayment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: single_payments
#
#  created_at     :datetime         not null
#  id             :integer          not null, primary key
#  name           :string
#  price          :float
#  sort           :integer          default(1)
#  special_label  :string
#  specifications :text
#  string_id      :string
#  thank_you_link :string
#  updated_at     :datetime         not null
#
