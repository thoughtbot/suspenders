When 'I run the rake task "$task_name"' do |task_name|
  Dir.chdir('test_project') do
    system("rake #{task_name}")
  end
end

Then 'I see a successful response in the shell' do
  $?.to_i.should == 0
end
