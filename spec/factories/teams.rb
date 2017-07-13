FactoryGirl.define do
  factory :team do
    name { Faker::Name.team_name }
    code { Faker::Crypto.unique.md5.upcase[1..6] }
    num_players 11

    callback(:after_create) do |model|
      a_players = create_list(:user, 10, :player)
      model.players << a_players

      a_coaches = create_list(:user, 2, :coach)
      model.coaches << a_coaches

      model.subscriptions << model.club.subscriptions

      # FIXME: (2017-06-29) jon => I forget why the association is invalid.
      # Investigate.
      model.save(validate: false)
    end
  end
end

# == Schema Information
#
# Table name: teams
#
#  club_id     :integer
#  code        :string
#  created_at  :datetime         not null
#  deleted_at  :datetime
#  id          :integer          not null, primary key
#  logo        :string
#  name        :string
#  num_players :integer
#  position    :integer
#  slug        :string
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_teams_on_deleted_at  (deleted_at)
#  index_teams_on_slug        (slug) UNIQUE
#
