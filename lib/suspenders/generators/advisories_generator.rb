require_relative "base"

module Suspenders
  class AdvisoriesGenerator < Generators::Base
    def bundler_audit_gem
      gem "bundler-audit", require: false, group: %i[development test]
      Bundler.with_clean_env { run "bundle install" }
    end

    def rake_task
      copy_file "bundler_audit.rake", "lib/tasks/bundler_audit.rake"
      append_file "Rakefile", %{\ntask default: "bundle:audit"\n}
    end
  end
end
