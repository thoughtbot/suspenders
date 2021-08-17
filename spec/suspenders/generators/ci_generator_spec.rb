require "spec_helper"

RSpec.describe Suspenders::CiGenerator, type: :generator do
  it "generates and destroys Circle configuration with SimpleCov" do
    with_app_dir do
      generator = new_invoke_generator(Suspenders::CiGenerator)
      stub_bundle_install!(generator)
      generator.invoke_all

      expect(generator).to have_bundled.with_gemfile_matching(/simplecov/)
      expect("spec/spec_helper.rb")
        .to match_contents(/SimpleCov.coverage_dir/)
        .and(match_contents(/SimpleCov.start/))
        .and(have_no_syntax_error)
      expect("circle.yml").to exist_as_a_file

      generator = new_revoke_generator(Suspenders::CiGenerator)
      stub_bundle_install!(generator)
      generator.invoke_all

      expect("circle.yml").not_to exist_as_a_file
      expect("spec/spec_helper.rb").not_to match_contents(/SimpleCov/)
      expect("spec/spec_helper.rb").to have_no_syntax_error
      expect("Gemfile").to have_no_syntax_error.and(match_original_file)
      expect(generator).to have_bundled.with_gemfile_not_matching(/simplecov/)
    end
  end

  context "when it is a minitest project" do
    it "configures test_helper.rb instead of spec_helper.rb" do
      with_app_dir do
        delete_file "spec/spec_helper.rb"
        touch_file "test/test_helper.rb"

        generator = new_invoke_generator(Suspenders::CiGenerator)
        stub_bundle_install!(generator)
        generator.invoke_all

        expect("test/test_helper.rb")
          .to match_contents(/SimpleCov.coverage_dir/)
          .and(match_contents(/SimpleCov.start/))
          .and(have_no_syntax_error)
      end
    end
  end
end
