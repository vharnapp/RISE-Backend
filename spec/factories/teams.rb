FactoryGirl.define do
  factory :team do
    name "MyString"
  end
end

# == Schema Information
#
# Table name: teams
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string
#  updated_at :datetime         not null
#
