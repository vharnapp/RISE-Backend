class ClubSerializer < ActiveModel::Serializer
  attributes :id, :name
end

# == Schema Information
#
# Table name: clubs
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string
#  updated_at :datetime         not null
#
