class AffiliationsController < ApplicationController
  load_and_authorize_resource

  def destroy
    @player = @affiliation.user
    @team = @affiliation.team
    @affiliation.destroy
    flash[:notice] = "#{@player.full_name} removed from #{@team.name}."
    redirect_to club_team_path(@team.club, @team)
  end
end
