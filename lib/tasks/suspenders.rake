namespace :suspenders do
  desc "Extend the default Rails Rake task"
  task :rake do
    if Bundler.rubygems.find_name("bundler-audit").any?
      Rake::Task[:"bundle:audit"].invoke
    end

    if Bundler.rubygems.find_name("standard").any?
      Rake::Task[:standard].invoke
    end
  end
end
