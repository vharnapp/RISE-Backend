class TeamsController < ApplicationController
  load_and_authorize_resource :club
  load_and_authorize_resource :team, through: :club, shallow: true

  def index
    redirect_to club_path(@club)
  end

  def show
    @players = @team.players.order('LOWER(last_name) asc')
    @pyramid_modules = PyramidModule.where('level < ?', 5).order(:position)
  end
end
