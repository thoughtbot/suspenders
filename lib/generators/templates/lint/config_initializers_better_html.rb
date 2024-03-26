Rails.configuration.to_prepare do
  if Rails.env.test?
    require "better_html"

    BetterHtml.config = BetterHtml::Config.new(Rails.configuration.x.better_html)

    BetterHtml.config.template_exclusion_filter = proc { |filename| !filename.start_with?(Rails.root.to_s) }
  end
end
