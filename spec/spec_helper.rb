require "bundler/setup"

Bundler.require(:default, :test)

require (Pathname.new(__FILE__).dirname + "../lib/suspenders").expand_path

Dir["./spec/support/*.rb"].sort.each { |file| require file }

RSpec.configure do |config|
  config.include FeatureTestHelpers, type: :feature
  config.include GeneratorTestHelpers, type: :generator

  config.before(:all) do
    FileOperations.create_tmp_path
    FakeOperations.add_fakes_to_path
  end

  config.before(:each, type: :feature) do |spec|
    next if spec.metadata.key?(:autoclean) && !spec.metadata[:autoclean]
    FileOperations.clear_tmp_path
  end
end
