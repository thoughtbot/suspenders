module Admin
  class UsersController < Admin::ApplicationController
    skip_before_action :require_admin!, only: [:stop_impersonating]
    respond_to :html
    load_resource

    def update
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
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

    private

    # :nocov:
    def resource_params
      params.require(resource_name).permit(
        *dashboard.permitted_attributes,
        roles: [],
      )
    end
    # :nocov:

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
