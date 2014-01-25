Before do
  ENV['TESTING'] = 'true'
  ENV['DISABLE_SPRING'] = 'true'
  @aruba_timeout_seconds = 560
end

After do
  FakeHeroku.clear!
  FakeGithub.clear!
  FileUtils.rm_rf 'test_project'
end
