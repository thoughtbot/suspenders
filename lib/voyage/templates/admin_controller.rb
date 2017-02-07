module Admin
  class AdminController < ApplicationController
    before_action :require_admin!
    skip_authorization_check

    private

    def require_admin!
      txt = 'You must be an admin to perform that action'
      redirect_to root_path, alert: txt unless current_user.admin?
    end
  end
end
