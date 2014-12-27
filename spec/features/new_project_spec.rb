require 'spec_helper'

feature 'Suspend a new project with default configuration' do
  scenario 'specs pass' do
    run_suspenders

    Dir.chdir(project_path) do
      Bundler.with_clean_env do
        expect(`rake`).to include('0 failures')
      end
    end
  end

  scenario 'staging config is inherited from production' do
    run_suspenders

    staging_file = IO.read("#{project_path}/config/environments/staging.rb")
    config_stub = "Rails.application.configure do"

    expect(staging_file).to match(/^require_relative "production"/)
    expect(staging_file).to match(/#{config_stub}/), staging_file
  end

  scenario 'generated .ruby-version is pulled from Suspenders .ruby-version' do
    run_suspenders

    ruby_version_file = IO.read("#{project_path}/.ruby-version")

    expect(ruby_version_file).to eq "#{RUBY_VERSION}\n"
  end

  scenario 'secrets.yml reads secret from env' do
    run_suspenders

    secrets_file = IO.read("#{project_path}/config/secrets.yml")

    expect(secrets_file).to match(/secret_key_base: <%= ENV\["SECRET_KEY_BASE"\] %>/)
  end

  scenario 'action mailer support file is added' do
    run_suspenders

    expect(File).to exist("#{project_path}/spec/support/action_mailer.rb")
  end

  scenario "i18n support file is added" do
    run_suspenders

    expect(File).to exist("#{project_path}/spec/support/i18n.rb")
  end

  scenario 'newrelic.yml reads NewRelic license from env' do
    run_suspenders

    newrelic_file = IO.read("#{project_path}/config/newrelic.yml")

    expect(newrelic_file).to match(
      /license_key: "<%= ENV\["NEW_RELIC_LICENSE_KEY"\] %>"/
    )
  end

  scenario 'records pageviews through Segment.io if ENV variable set' do
    run_suspenders

    expect(analytics_partial).
      to include(%{<% if ENV["SEGMENT_IO_KEY"] %>})
    expect(analytics_partial).
      to include(%{window.analytics.load("<%= ENV["SEGMENT_IO_KEY"] %>");})
  end

  scenario "raises on unpermitted parameters in all environments" do
    run_suspenders

    result = IO.read("#{project_path}/config/application.rb")

    expect(result).to match(
      /^ +config.action_controller.action_on_unpermitted_parameters = :raise$/
    )
  end

  scenario "raises on missing translations in development and test" do
    run_suspenders

    %w[development test].each do |environment|
      environment_file =
        IO.read("#{project_path}/config/environments/#{environment}.rb")
      expect(environment_file).to match(
        /^ +config.action_view.raise_on_missing_translations = true$/
      )
    end
  end

  scenario "specs for missing or unused translations" do
    run_suspenders

    expect(File).to exist("#{project_path}/spec/i18n_spec.rb")
  end

  scenario "config file for i18n tasks" do
    run_suspenders

    expect(File).to exist("#{project_path}/config/i18n-tasks.yml")
  end

  scenario "generated en.yml is evaluated" do
    run_suspenders

    locales_en_file = IO.read("#{project_path}/config/locales/en.yml")
    app_name = SuspendersTestHelpers::APP_NAME

    expect(locales_en_file).to match(/application: #{app_name.humanize}/)
  end

  scenario "config simple_form" do
    run_suspenders

    expect(File).to exist("#{project_path}/config/initializers/simple_form.rb")
  end

  def analytics_partial
    IO.read("#{project_path}/app/views/application/_analytics.html.erb")
  end
end
