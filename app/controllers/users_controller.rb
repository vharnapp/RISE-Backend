class UsersController < ApplicationController
  # https://github.com/CanCanCommunity/cancancan/wiki/authorizing-controller-actions
  load_and_authorize_resource
  skip_authorization_check only: [:analytics_alias]

  def analytics_alias
    # view file has JS that will identify the anonymous user through segment
    # after registration via "after devise registration path"
  end

  def show; end

  # def new; end

  # def create
  #   if @user.save
  #     flash[:notice] = "User successfully created#{@user.admin? ? ' as an admin' : ''}"
  #     redirect_to team_path(@user.teams.first)
  #   else
  #     render :new
  #   end
  # end

  # private

  # def user_params
  #   params.require(:user).permit(
  #     :first_name,
  #     :last_name,
  #     :email,
  #     :password,
  #     :password_confirmation,
  #     :current_password,
  #     :team_ids,
  #   )
  # end
end
