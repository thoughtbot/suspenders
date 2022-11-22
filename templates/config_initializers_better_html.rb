Rails.configuration.to_prepare do
  config = ActiveSupport::ConfigurationFile.parse("config/better_html.yml")

  BetterHtml.config = BetterHtml::Config.new(config)
end
