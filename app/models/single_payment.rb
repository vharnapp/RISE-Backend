class SinglePayment < ApplicationRecord

  has_and_belongs_to_many :pyramid_module
  belongs_to :user, optional: true

end

# == Schema Information
#
# Table name: single_payments
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string
#  price      :float
#  updated_at :datetime         not null
#
