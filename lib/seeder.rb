# rubocop:disable Rails/Output
module Seeder
  module_function

  def admin_user
    puts '-----> Creating Admin User'

    # Remove all admins
    User.admins.destroy_all

    create(:user, :admin)
  end

  def all_users
    puts '-----> Resetting to a clean user list with all Users'

    # Remove all users
    User.unscoped.find_each(&:really_destroy!)

    # list user traits from factory_girl here
    %w[admin].each do |name|
      create(:user, name.to_sym)
    end
  end

  def two_clubs_with_teams_and_coaches_and_players
    puts '-----> Creating two clubs, and 5 teams with 10 players each'

    Club.unscoped.find_each(&:really_destroy!)

    2.times do
      club = create(:club)
      5.times do
        create(:team, club: club)
      end
    end
  end
end

# rubocop:disable Metrics/LineLength
if Rails.env == 'production'
  unless ENV['FORCE_SEED']
    puts
    puts '================================================================================='
    puts 'WARNING: You are trying to run db:seed on production. This is a DESTRUCTIVE task.'
    puts 'If you know what you are doing, you can override by setting environment variable '
    puts 'FORCE_SEED=1'
    abort('Exiting now...')
  end
end
# rubocop:enable Rails/Output, Metrics/LineLength
