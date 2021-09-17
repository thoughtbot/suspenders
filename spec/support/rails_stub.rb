module RailsStub
  extend RSpec::Mocks::ExampleMethods

  module_function

  def stub_app_class(app_class_name: nil)
    require "active_support/core_ext/module/introspection"

    fake_app_class = Class.new do
      define_singleton_method(:name) do
        app_class_name || "RandomApp::Application"
      end
    end

    allow(Rails).to receive(:app_class).and_return(fake_app_class)
  end
end
