require_relative "base"

module Suspenders
  class AdvisoriesGenerator < Generators::Base
    def bundler_audit_gem
      gem "bundler-audit",
          require: false,
          group: %i[development test],
          git: "https://github.com/rubysec/bundler-audit.git",
          branch: "0.7.0"
      Bundler.with_clean_env { run "bundle install" }
    end

    def rake_task
      copy_file "bundler_audit.rake", "lib/tasks/bundler_audit.rake"
      append_file "Rakefile", %{\ntask default: "bundle:audit"\n}
    end
  end
end
