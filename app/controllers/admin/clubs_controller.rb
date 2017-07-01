module Admin
  class ClubsController < Admin::ApplicationController
    def new
      club = resource_class.new

      club.subscriptions.build(
        start_date: Time.zone.today,
        end_date: 1.year.from_now,
      )

      render locals: {
        page: Administrate::Page::Form.new(dashboard, club),
      }
    end

    def create
      resource = resource_class.new(resource_params)

      if resource.save
        if resource.teams_csv.present?
          create_teams_and_coaches_via_csv(resource)
        else
          create_teams_and_coaches(resource)
        end

        redirect_to(
          [namespace, resource],
          notice: translate_with_resource('create.success'),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
        }
      end
    end

    private

    def create_teams_and_coaches_via_csv(resource)
      csv_data = resource.teams_csv.read

      csv = CSV.parse(csv_data, headers: true)

      csv.each do |row|
        team = resource.teams.where(
          name: row['name'],
          num_players: row['num_players'],
        ).first_or_create!

        coach = User.find_by(email: row['coach_email'])

        if coach.blank?
          coach = team.coaches.create!(
            first_name: row['coach_first_name'],
            last_name: row['coach_last_name'],
            password: 'asdfjkl123',
            password_confirmation: 'asdfjkl123',
            email: row['coach_email'],
          )
        else
          team.coaches << coach
          team.save
        end

        coach.roles << [:coach]
        coach.save!
      end
    end

    def create_teams_and_coaches(resource)
      resource.temp_teams.each do |temp_team|
        team = resource.teams.where(
          name: temp_team.name,
          num_players: temp_team.num_players,
        ).first_or_create!

        coach = User.find_by(email: temp_team.coach_email)

        if coach.blank?
          coach = team.coaches.create!(
            first_name: temp_team.coach_first_name,
            last_name: temp_team.coach_last_name,
            password: 'asdfjkl123',
            password_confirmation: 'asdfjkl123',
            email: temp_team.coach_email,
          )
        else
          team.coaches << coach
          team.save
        end

        coach.roles << [:coach]
        coach.save!
      end

      resource.temp_teams.destroy_all
    end
  end
end
