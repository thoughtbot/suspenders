require "spec_helper"

# TODO: Make sure db optimizations is covered at integration level
RSpec.describe Suspenders::DbOptimizationsGenerator, type: :generator do
  it "generates and destroys bullet" do
    silence do
      generator = new_invoke_generator(Suspenders::DbOptimizationsGenerator)
      stub_bundle_install!(generator)
      generator.invoke_all

      expect(generator).to have_bundled.with_gemfile_matching(/bullet/)
      expect("config/environments/development.rb").to \
        match_contents(/Bullet.enable/)

      generator = new_revoke_generator(Suspenders::DbOptimizationsGenerator)
      stub_bundle_install!(generator)
      generator.invoke_all

      expect(generator).to have_bundled.with_gemfile_not_matching(/bullet/)
      expect("Gemfile").to match_original_file
      expect("config/environments/development.rb").not_to \
        match_contents(/Bullet.enable/)
      expect("config/environments/development.rb").to match_original_file
    end
  end
end
