class TeamsController < ApplicationController
  load_and_authorize_resource

  def index
    @club = Club.find(params[:club_id])
    @teams = Team.all
  end

  def show; end

  def new
    @team = Team.new
  end

  def edit; end

  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to club_path(@team.club), notice: 'Team was successfully created.'
    else
      render :new
    end
  end

  def update
    if @team.update(team_params)
      redirect_to teams_path, notice: 'Team was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: 'Team was successfully destroyed.'
  end

  private

  def team_params
    params.require(:team).permit(
      :name,
      :club_id,
    )
  end
end
