module Admin
  module ApplicationHelper
    include AdministrateResourcesHelper

    def sanitized_order_params
      resources =
        Administrate::Namespace.new(:admin)
                               .resources
                               .map(&:resource)
                               .map(&:to_sym)

      params.permit(
        *resources,
        :search,
        :id,
        :order,
        :page,
        :per_page,
        :direction,
      )
    end
  end
end
