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
end
