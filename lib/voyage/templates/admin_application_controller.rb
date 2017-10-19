# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    include AnalyticsTrack

    before_action :authenticate_user!,
                  unless: -> { is_a?(HighVoltage::PagesController) }
    before_action :require_admin!

    skip_authorization_check
    impersonates :user

    private

    def require_admin!
      txt = 'You must be an admin to perform that action'
      redirect_to root_path, alert: txt unless current_user.admin?
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
