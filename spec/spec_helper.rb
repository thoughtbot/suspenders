require "bundler/setup"

Bundler.require(:default, :test)

require (Pathname.new(__FILE__).dirname + "../lib/suspenders").expand_path

Dir["./spec/support/*.rb"].sort.each { |file| require file }

RSpec.configure do |config|
  config.include FeatureTestHelpers, type: :feature
  config.include GeneratorTestHelpers, type: :generator

  config.before(:all, type: :feature) do
    add_fakes_to_path
    create_tmp_directory
  end

  config.before(:each, type: :feature) do
    FakeGithub.clear!
  end

  config.before(:each, type: :feature) do |spec|
    next if spec.metadata.key?(:autoclean) && !spec.metadata[:autoclean]
    remove_project_directory
  end
end
