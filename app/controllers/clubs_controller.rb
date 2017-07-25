class ClubsController < ApplicationController
  load_and_authorize_resource

  def index
    @clubs = @clubs.includes(:administrators)
    redirect_to club_path(@clubs.first) if @clubs.length == 1 || current_user.coach?
  end

  def show
    @teams = @club.my_teams(current_user).includes(:club, :coaches)
    redirect_to club_team_path(@club, @teams.first) if current_user.coach?
  end
end
