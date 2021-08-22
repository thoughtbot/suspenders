require_relative "base"

module Suspenders
  class AdvisoriesGenerator < Generators::Base
    def bundler_audit_gem
      gem "bundler-audit", ">= 0.7.0", require: false, group: %i[development test]
      Bundler.with_unbundled_env { run "bundle install" }
    end

    def rake_task
      copy_file "bundler_audit.rake", "lib/tasks/bundler_audit.rake"
      append_file "Rakefile", %(\ntask default: "bundle:audit"\n)
    end
  end
end
