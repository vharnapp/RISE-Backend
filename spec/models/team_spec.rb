require 'rails_helper'

RSpec.describe Team, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'associations' do
    it { is_expected.to have_many(:affiliations) }
    it { is_expected.to have_many(:coach_affiliations) }
    it { is_expected.to have_many(:player_affiliations) }
    it { is_expected.to have_many(:coaches) }
    it { is_expected.to have_many(:players) }
  end
end

# == Schema Information
#
# Table name: teams
#
#  club_id    :integer
#  code       :string
#  created_at :datetime         not null
#  deleted_at :datetime
#  id         :integer          not null, primary key
#  name       :string
#  position   :integer
#  slug       :string
#  updated_at :datetime         not null
#
# Indexes
#
#  index_teams_on_deleted_at  (deleted_at)
#  index_teams_on_slug        (slug) UNIQUE
#
