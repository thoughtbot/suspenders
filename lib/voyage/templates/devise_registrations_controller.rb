module DeviseCustomizations
  class RegistrationsController < Devise::RegistrationsController
    def create
      super
    end

    protected

    def after_sign_up_path_for(resource)
      analytics_alias_user_path(resource)
    end
  end
end
