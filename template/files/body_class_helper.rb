module BodyClassHelper
  # TODO: move this into a gem/plugin
  def body_class
    qualified_controller_name = controller.controller_path.gsub('/','-')
    "#{qualified_controller_name} #{qualified_controller_name}-#{controller.action_name}"
  end
end
