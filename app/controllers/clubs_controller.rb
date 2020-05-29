class ClubsController < ApplicationController
  load_and_authorize_resource

  def index

    # TODO: (2018-01-13) jon => remove this if the subscriptions_controller#check_subscription method covers the same use case
    if @clubs.blank?
      flash[:notice] = %(
        Your account is not associated to a club. Please contact
        <a href='mailto:info@risefutbol.com'>info@risefutbol.com</a> for
        support.
      ).html_safe.squish # rubocop:disable Rails/OutputSafety

      redirect_to '/help' and return
    end
    
    @clubs = @clubs.includes(:administrators)

    first_club_path = club_path(@clubs.first)
    redirect_to first_club_path if @clubs.length == 1 || current_user.coach?
  end

  def show
    @teams = @club.my_teams(current_user).includes(:club, :coaches)
    redirect_to club_team_path(@club, @teams.first) if current_user.coach?
  end
end
