class Affiliation < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :team

  scope :coaches, (-> { where(coach: true) })
  scope :players, (-> { where(coach: false) })

  def title
    coach ? 'Coach' : 'Player'
  end
end

# == Schema Information
#
# Table name: affiliations
#
#  coach      :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  deleted_at :datetime
#  id         :integer          not null, primary key
#  level      :integer
#  position   :integer
#  prereq     :text             default([]), is an Array
#  team_id    :integer
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_affiliations_on_deleted_at  (deleted_at)
#  index_affiliations_on_team_id     (team_id)
#  index_affiliations_on_user_id     (user_id)
#
