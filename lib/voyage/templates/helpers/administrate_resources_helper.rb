module AdministrateResourcesHelper
  # All associated resources are required to have routes and dashboards,
  # but may not need to appear in the left menu.
  # NOTE: Add resource names here to hide them in the Administrate sidebar.
  def resources_to_ignore
    %w[]
  end

  def resources_for_sidebar_nav
    Administrate::Namespace
      .new(:admin)
      .resources
      .reject do |resource_obj|
        resources_to_ignore.include?(resource_obj.resource)
      end
  end
end
