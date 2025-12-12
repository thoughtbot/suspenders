require "tmpdir"

module ActionTestHelpers
  def setup_action(action_class)
    within_temp_app do |app_dir|
      action = action_class.new
      action.destination_root = app_dir
      file_path = File.join app_dir, action_class::TARGET_FILE
      yield action, file_path
    end
  end

  def within_temp_app
    Dir.mktmpdir do |dir|
      yield dir
    end
  end

  def write_file(file_path, content)
    FileUtils.mkdir_p File.dirname(file_path)
    File.write file_path, content
  end
end

RSpec.configure do |config|
  config.include ActionTestHelpers
end
