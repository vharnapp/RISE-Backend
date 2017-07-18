class TeamsController < ApplicationController
  load_and_authorize_resource :club
  load_and_authorize_resource :team, through: :club, shallow: true

  def index
    redirect_to club_path(@club)
  end

  def show
    @players = @team.players

    @pyramid_modules =
      PyramidModule.where('level < ?', 5).order(:position)
  end

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
