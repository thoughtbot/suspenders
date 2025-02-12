require "test_helper"

class Suspenders::GeneratorsTest < ActiveSupport::TestCase
  class HelpersTest < ActiveSupport::TestCase
    include Suspenders::TestHelpers
    include Suspenders::Generators::Helpers

    test "database_adapter returns the current database" do
      with_database "postgresql" do
        assert_equal database_adapter, "postgresql"
      end
    end
  end

  class APIAppUnsupportedTest < ActiveSupport::TestCase
    test "message returns a custom message" do
      expected = "This generator cannot be used on API only applications."

      assert_equal expected, Suspenders::Generators::APIAppUnsupported::Error.new.message
    end
  end

  class DatabaseUnsupportedTest < ActiveSupport::TestCase
    test "message returns a custom message" do
      expected = "This generator requires either PostgreSQL or SQLite"

      assert_equal expected, Suspenders::Generators::DatabaseUnsupported::Error.new.message
    end
  end

  class NodeNotInstalledTest < ActiveSupport::TestCase
    test "message returns a custom message" do
      expected = "This generator requires Node"

      assert_equal expected, Suspenders::Generators::NodeNotInstalled::Error.new.message
    end
  end

  class NodeVersionUnsupportedTest < ActiveSupport::TestCase
    test "message returns a custom message" do
      expected = "This generator requires Node >= #{Suspenders::MINIMUM_NODE_VERSION}"

      assert_equal expected, Suspenders::Generators::NodeVersionUnsupported::Error.new.message
    end
  end
end
