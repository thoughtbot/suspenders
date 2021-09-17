require "bundler/setup"

Bundler.require(:default, :test)

require (Pathname.new(__FILE__).dirname + "../lib/suspenders").expand_path

Dir["./spec/support/*.rb"].sort.each { |file| require file }

RSpec.configure do |config|
  config.include FeatureTestHelpers, type: :feature
  config.include GeneratorTestHelpers, type: :generator

  config.before(:all) do
    FileOperations.create_tmp_directory
    EnvPath.prepend_env_path!(TestPaths.fake_bin_path)
  end
end
