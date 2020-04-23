class SinglePayment < ApplicationRecord

  has_and_belongs_to_many :pyramid_modules
  belongs_to :user, optional: true

  default_scope { order(sort: :asc) }

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
