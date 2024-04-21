module Suspenders
  module Generators
    module Environments
      class ProductionGenerator < Rails::Generators::Base
        desc <<~MARKDOWN
          - Enables [require_master_key][].

          [require_master_key]: https://guides.rubyonrails.org/configuring.html#config-require-master-key
        MARKDOWN

        def require_master_key
          if production_config.match?(/^\s*#\s*config\.require_master_key\s*=\s*true/)
            uncomment_lines "config/environments/production.rb", /config\.require_master_key\s*=\s*true/
          else
            environment %(config.require_master_key = true), env: "production"
          end
        end

        private

        def production_config
          File.read(Rails.root.join("config/environments/production.rb"))
        end
      end
    end
  end
end
