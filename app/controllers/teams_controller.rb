class TeamsController < ApplicationController
  load_and_authorize_resource :club
  load_and_authorize_resource :team, through: :club, shallow: true

  def index
    @teams = if current_user.coach? || current_user.club_admin?
               current_user.teams
             else
               @club.try(:teams)
             end
  end

  def show; end

  def edit; end

  def update
    if @team.update(team_params)
      flash[:notice] = 'Team was successfully updated.'
      redirect_to club_team_path(@club, @team)
    else
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to club_path(@club), notice: 'Club was successfully destroyed.'
  end

  private

  def team_params
    params.require(:team).permit(
      :name,
      :code,
    )
  end
end
