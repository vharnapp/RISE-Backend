class TeamsController < ApplicationController
  load_and_authorize_resource :club
  load_and_authorize_resource through: :club

  def show; end

  def new
    @team = Team.new
  end

  def edit; end

  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to club_path(@club), notice: 'Team was successfully created.'
    else
      render :new
    end
  end

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
      :club_id,
      :code,
    )
  end
end
