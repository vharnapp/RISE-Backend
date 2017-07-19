class ClubsController < ApplicationController
  load_and_authorize_resource

  def index
    @clubs = @clubs.includes(:administrators)
    redirect_to club_path(@clubs.first) if @clubs.length == 1
  end

  def show
    @teams = @club.teams.includes(:club, :coaches)
  end

  def edit; end

  def update
    if @club.update(club_params)
      redirect_to clubs_path, notice: 'Club was successfully updated.'
    else
      render :edit
    end
  end

  private

  def club_params
    params.require(:club).permit(:name)
  end
end
