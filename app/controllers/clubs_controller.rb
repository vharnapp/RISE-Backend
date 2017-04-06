class ClubsController < ApplicationController
  load_and_authorize_resource

  def index
    @clubs = Club.all
  end

  def show; end

  def new
    @club = Club.new
  end

  def edit; end

  def create
    @club = Club.new(club_params)

    if @club.save
      redirect_to clubs_path, notice: 'Club was successfully created.'
    else
      render :new
    end
  end

  def update
    if @club.update(club_params)
      redirect_to clubs_path, notice: 'Club was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @club.destroy
    redirect_to clubs_url, notice: 'Club was successfully destroyed.'
  end

  private

  def club_params
    params.require(:club).permit(:name)
  end
end
