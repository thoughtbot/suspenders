Then /^"(.*)" should not be installed$/ do |gem_name|
  in_current_dir do
    system("bundle show #{gem_name} 2>&1 > /dev/null").should be_false
  end
end
