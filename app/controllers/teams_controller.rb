class TeamsController < ApplicationController
  load_and_authorize_resource :club
  load_and_authorize_resource :team, through: :club, shallow: true

  def index
    redirect_to club_path(@club)
  end

  def show
    @page = params[:page].to_i
    @page = @page > 0 ? @page - 1 : 0
    count = @team.players.count()
    player_per_page = 30
    offset = @page * player_per_page
    @max_page = count / player_per_page

    if (@page > @max_page)
      redirect_url = @max_page > 0 ? "/clubs/#{params[:club_id]}/teams/#{params[:id]}/#{@max_page + 1}" : "/clubs/#{params[:club_id]}/teams/#{params[:id]}"
      redirect_to redirect_url
    end

    @max_page = @max_page + 1;
    @page = @page + 1;
    @base_page_url = "/clubs/#{params[:club_id]}/teams/#{params[:id]}"
    @page_start = 1
    @page_end = @max_page

    if @max_page > 9
      if @page < 7
          @page_end = @page + 4
      else
        if @page > @max_page - 7
          @page_start = @page - 4
          @page_end = @max_page
        else
          @page_start = @page - 4
          @page_end = @page + 4
        end
      end
    end

    @players = @team.players.order('LOWER(first_name) asc').order('LOWER(last_name) asc').limit(player_per_page).offset(offset)
    @pyramid_modules = PyramidModule.where('level < ?', 5).order(:position)
  end

  def get_teams
    @team = Team.select(:id, :name).where(club_id: params[:club_id])
    
    #json_request json: @team.to_json.to_json

    #respond_to do |format|
    #  format.html { render html: "Hello World!" }
    #  format.json { render json: @team.to_json }
    #end

    render json: @team.to_json
  end
end
