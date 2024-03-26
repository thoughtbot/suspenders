require "test_helper"
require "tempfile"
require_relative "../../lib/suspenders/organize_gemfile"

module Suspenders
  class OrganizeGemfileTest < ActiveSupport::TestCase
    test "organizes gemfile by group" do
      original = file_fixture("gemfile_messy")
      modified = file_fixture("gemfile_clean")

      Tempfile.create "Gemfile" do |gemfile|
        gemfile.write original.read
        gemfile.rewind

        Suspenders::OrganizeGemfile.perform(gemfile)

        assert_equal modified.read, gemfile.read
      end
    end
  end
end
