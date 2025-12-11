require "test_helper"

class SuspendersTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert Suspenders::VERSION
  end

  test "it has a Rails version number" do
    assert Suspenders::RAILS_VERSION
  end

  test "it has a Minimum Ruby version number" do
    assert Suspenders::MINIMUM_RUBY_VERSION
  end

  test "it has a Minimum Node version number" do
    assert Suspenders::MINIMUM_NODE_VERSION
  end

  test ".run creates a new Rails application when the app name is valid" do
    Suspenders::CLI.any_instance.stubs(:system).returns(true)

    result = Suspenders::CLI.run("test_app")
    assert_equal true, result
  end

  test ".run does not create a new Rails application when the app name is invalid" do
    Suspenders::CLI.any_instance.stubs(:system).returns(true, false)

    result = Suspenders::CLI.run("")
    assert_equal false, result
  end

  test ".run raises an error when Rails is not installed" do
    Suspenders::CLI.any_instance
      .stubs(:system)
      .with("which", "rails", out: File::NULL, err: File::NULL)
      .returns(false)

    error = assert_raises(Suspenders::Error) do
      Suspenders::CLI.run("app_name")
    end

    assert_equal "Rails not found. Install with: gem install rails", error.message
  end
end
