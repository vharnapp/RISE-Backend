module Admin
  class UsersController < AdminController
    skip_before_action :require_admin!, only: [:stop_impersonating]
    before_action :set_user, only: [:destroy, :edit, :update]
    respond_to :html, :json

    def index
      @users = User.all

      respond_with(@users)
    end

    def new
      @user = User.new
    end

    # TODO: (2017-04-08) jon => extract this to a service object or form object
    # after looking at the wireframes and figuring out how the UI will handle
    # these user additions.
    # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/LineLength
    def create
      @user = User.new(user_params)

      %i[admin club_admin coach player].each do |role|
        next unless params[role] && params[role] == 'true'
        @user.roles << role
      end

      if @user.save
        team_id = params['user']['team_ids'].reject(&:blank?).first
        if params[:coach] && params[:coach] == 'true'
          a = Affiliation.find_by(user_id: @user.id, team_id: team_id)
          a.update(coach: true)
        end

        if params[:player] && params[:player] == 'true'
          attrs = { user_id: @user.id, team_id: team_id, coach: false }
          Affiliation.where(attrs).first_or_create
        end

        flash[:notice] = "User successfully created as: #{@user.role_list}"
        team = Team.find(team_id) if team_id
        if team
          redirect_to club_team_path(team.club, team)
        else
          redirect_to admin_users_path
        end
      else
        render :new
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/LineLength

    def edit; end

    def update
      if @user.update(user_params)
        flash[:notice] = 'User successfully updated'
        redirect_to admin_users_path
      else
        flash[:error] = 'An error occurred'
        render :edit
      end
    end

    def destroy
      @user.destroy
      flash[:notice] = 'User successfully destroyed'
      redirect_to admin_users_path
    end

    def impersonate
      user = User.find(params[:id])
      track_impersonation(user, 'Start')
      impersonate_user(user)
      redirect_to root_path
    end

    def stop_impersonating
      track_impersonation(current_user, 'Stop')
      stop_impersonating_user
      redirect_to admin_users_path
    end

    private

    def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :email,
        :password,
        :password_confirmation,
        :current_password,
        team_ids: [],
      )
    end

    def set_user
      @user = User.find(params[:id])
    end

    def track_impersonation(user, status)
      analytics_track(
        true_user,
        "Impersonation #{status}",
        impersonated_user_id: user.id,
        impersonated_user_email: user.email,
        impersonated_by_email: true_user.email,
      )
    end
  end
end
