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

  desc "Ensure a migration is reversible"
  namespace :db do
    task :migrate do
      Rake::Task["db:migrate"].invoke
      Rake::Task["db:rollback"].invoke

      Rake::Task["db:migrate"].reenable
      Rake::Task["db:migrate"].invoke

      Rake::Task["db:test:prepare"].invoke
    end
  end

  namespace :cleanup do
    desc "Organizes Gemfile"
    task organize_gemfile: :environment do
      Suspenders::Cleanup::OrganizeGemfile.perform(Rails.root.join("Gemfile"))
    end

    desc "Generate README"
    task :generate_readme do
      Suspenders::Cleanup::GenerateReadme.perform(Rails.root.join("README.md"), Rails.application.class.module_parent_name)
    end
  end
end
