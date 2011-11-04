Before do
  ENV['TESTING'] = 'true'
end

After do
  FakeHeroku.clear!
end
