require "test_helper"
require "tempfile"
require_relative "../../../lib/suspenders/cleanup/organize_gemfile"

module Suspenders
  module Cleanup
    class OrganizeGemfileTest < ActiveSupport::TestCase
      test "organizes Gemfile by group" do
        original = file_fixture("gemfile_messy").read
        modified = file_fixture("gemfile_clean").read

        Tempfile.create "Gemfile" do |gemfile|
          gemfile.write original
          gemfile.rewind

          Suspenders::Cleanup::OrganizeGemfile.perform(gemfile.path)

          assert_equal modified, gemfile.read
        end
      end
    end
  end
end
