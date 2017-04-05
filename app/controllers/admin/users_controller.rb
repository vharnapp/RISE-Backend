module Admin
  class UsersController < AdminController
    skip_before_action :require_admin!, only: [:stop_impersonating]
    before_action :set_user, only: [:destroy, :edit, :update]
    respond_to :html, :json

    def index
      @users = User.all

      respond_with(@users)
    end

    def destroy
      @user.destroy
      flash[:notice] = 'User destroyed'
      redirect_to admin_users_path
    end

    def edit; end

    def update
      if @user.update(user_params)
        flash[:notice] = 'User successfully destroyed'
        redirect_to admin_users_path
      else
        flash[:error] = 'An error occurred'
        render :edit
      end
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
