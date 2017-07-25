module Admin
  class UsersController < Admin::ApplicationController
    skip_before_action :authenticate_admin, only: [:stop_impersonating]

    before_action :default_params

    def create
      @user = User.invite!(resource_params) do |u|
        u.skip_invitation = true
      end

      flash[:notice] = 'User successfully created, but not yet invited.'
      redirect_to admin_users_path
    end

    def update
      params[:user].delete(:password) if params[:user][:password].blank?
      params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?
      super
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

    def invite
      user = User.find(params[:id])
      user.invite!(current_user)
      redirect_to admin_users_path
    end

    private

    def resource_params
      params.require(resource_name).permit(
        *dashboard.permitted_attributes,
        team_ids: [],
        roles: [],
      )
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

    def default_params
      params[:order] ||= 'created_at'
      params[:direction] ||= 'desc'
    end
  end
end
