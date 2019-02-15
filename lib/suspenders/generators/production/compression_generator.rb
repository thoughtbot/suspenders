require_relative "../base"

module Suspenders
  module Production
    class CompressionGenerator < Generators::Base
      def add_rack_deflater
        configure_environment(
          :production,
          %{config.middleware.use Rack::Deflater},
        )
      end
    end
  end
end
