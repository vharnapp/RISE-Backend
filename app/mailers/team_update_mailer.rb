class TeamUpdateMailer < ApplicationMailer
  def player_removed_from_team(player_id, team_id)
    @player = User.find(player_id)
    @team = Team.find(team_id)

    mail(
      to: @player.email,
      cc: @team.coaches.map(&:email),
      subject: "#{@player.full_name} was removed from the following team: #{@team.name}",
    )
  end
end
