Before do
  ENV['TESTING'] = 'true'
end

After do
  FileUtils.rm_rf File.expand_path(File.join('..', '..', 'tmp', 'heroku_commands'), File.dirname(__FILE__))
end
