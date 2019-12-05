if ENV.fetch("COVERAGE", false)
  require "simplecov"

  if ENV["CIRCLE_ARTIFACTS"]
    dir = File.join(ENV["CIRCLE_ARTIFACTS"], "coverage")
    SimpleCov.coverage_dir(dir)
  end


  SimpleCov.start "rails"

  if defined?(Spring) && ENV["DISABLE_SPRING"].to_i == 1
    Rails.application.eager_load!
  end
end

