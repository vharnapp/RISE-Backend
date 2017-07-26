class Snippet < ApplicationRecord
  acts_as_paranoid
  acts_as_list

  extend FriendlyId
  friendly_id :name

  validates :name, :content, presence: true
end

# == Schema Information
#
# Table name: snippets
#
#  content    :text
#  created_at :datetime         not null
#  deleted_at :datetime
#  id         :integer          not null, primary key
#  name       :string
#  position   :integer
#  slug       :string
#  updated_at :datetime         not null
#
