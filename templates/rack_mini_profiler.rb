# frozen_string_literal: true

if ENV["RACK_MINI_PROFILER"].to_i > 0
  require "rack-mini-profiler"

  Rack::MiniProfilerRails.initialize!(Rails.application)
end
