require "spec_helper"

RSpec.describe "Suspend a new project with default configuration" do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    run_suspenders
    setup_app_dependencies
  end

  it "uses custom Gemfile" do
    gemfile_file = IO.read("#{project_path}/Gemfile")
    expect(gemfile_file).to match(
      /^ruby "#{Suspenders::RUBY_VERSION}"$/,
    )
    expect(gemfile_file).to match(
      /^gem "autoprefixer-rails"$/,
    )
    expect(gemfile_file).to match(
      /^gem "rails", "#{Suspenders::RAILS_VERSION}"$/,
    )
  end

  it "ensures project specs pass" do
    Dir.chdir(project_path) do
      Bundler.with_clean_env do
        expect(`rake`).to include('0 failures')
      end
    end
  end

  it "includes the bundle:audit task" do
    Dir.chdir(project_path) do
      Bundler.with_clean_env do
        expect(`rails -T`).to include("rails bundle:audit")
      end
    end
  end

  it "creates .ruby-version from Suspenders .ruby-version" do
    ruby_version_file = IO.read("#{project_path}/.ruby-version")

    expect(ruby_version_file).to eq "#{RUBY_VERSION}\n"
  end

  it "copies dotfiles" do
    %w[.ctags .env].each do |dotfile|
      expect(File).to exist("#{project_path}/#{dotfile}")
    end
  end

  it "doesn't generate test directory" do
    expect(File).not_to exist("#{project_path}/test")
  end

  it "loads secret_key_base from env" do
    secrets_file = IO.read("#{project_path}/config/secrets.yml")

    expect(secrets_file).
      to match(/secret_key_base: <%= ENV\["SECRET_KEY_BASE"\] %>/)
  end

  it "adds bin/setup file" do
    expect(File).to exist("#{project_path}/bin/setup")
  end

  it "makes bin/setup executable" do
    expect("bin/setup").to be_executable
  end

  it "adds support file for action mailer" do
    expect(File).to exist("#{project_path}/spec/support/action_mailer.rb")
  end

  it "configures capybara-chromedriver" do
    expect(File).to exist("#{project_path}/spec/support/chromedriver.rb")
  end

  it "adds support file for i18n" do
    expect(File).to exist("#{project_path}/spec/support/i18n.rb")
  end

  it "creates good default .hound.yml" do
    hound_config_file = IO.read("#{project_path}/.hound.yml")

    expect(hound_config_file).to include "enabled: true"
  end

  it "ensures Gemfile contains `rack-mini-profiler`" do
    gemfile = IO.read("#{project_path}/Gemfile")

    expect(gemfile).to include %{gem "rack-mini-profiler", require: false}
  end

  it "ensures .sample.env defaults to RACK_MINI_PROFILER=0" do
    env = IO.read("#{project_path}/.env")

    expect(env).to include "RACK_MINI_PROFILER=0"
  end

  it "initializes ActiveJob to avoid memory bloat" do
    expect(File).
      to exist("#{project_path}/config/initializers/active_job.rb")
  end

  it "creates a rack-mini-profiler initializer" do
    expect(File).
      to exist("#{project_path}/config/initializers/rack_mini_profiler.rb")
  end

  it "records pageviews through Segment if ENV variable set" do
    expect(analytics_partial).
      to include(%{<% if ENV["SEGMENT_KEY"] %>})
    expect(analytics_partial).
      to include(%{analytics.load("<%= ENV["SEGMENT_KEY"] %>");})
  end

  it "raises on unpermitted parameters in all environments" do
    result = IO.read("#{project_path}/config/application.rb")

    expect(result).to match(
      /^ +config.action_controller.action_on_unpermitted_parameters = :raise$/
    )
  end

  it "adds explicit quiet_assets configuration" do
    result = IO.read("#{project_path}/config/application.rb")

    expect(result).to match(/^ +config.assets.quiet = true$/)
  end

  it "configures public_file_server.headers in production" do
    expect(production_config).to match(
      /^ +config.public_file_server.headers = {\n +"Cache-Control" => "public,/,
    )
  end

  it "configures production environment to enforce SSL" do
    expect(production_config).to match(
      /^ +config.force_ssl = true/,
    )
  end

  it "raises on missing translations in development and test" do
    [development_config, test_config].each do |environment_file|
      expect(environment_file).to match(
        /^ +config.action_view.raise_on_missing_translations = true$/
      )
    end
  end

  it "evaluates en.yml.erb" do
    locales_en_file = IO.read("#{project_path}/config/locales/en.yml")

    expect(locales_en_file).to match(/application: #{app_name.humanize}/)
  end

  it "configs simple_form" do
    expect(File).to exist("#{project_path}/config/initializers/simple_form.rb")
  end

  it "configs :test email delivery method for development" do
    expect(development_config).
      to match(/^ +config.action_mailer.delivery_method = :file$/)
  end

  it "sets action mailer default host and asset host" do
    config_key = 'config\.action_mailer\.asset_host'
    config_value =
      %q{ENV\.fetch\("ASSET_HOST", ENV\.fetch\("APPLICATION_HOST"\)\)}
    expect(production_config).to match(/#{config_key} = #{config_value}/)
  end

  it "uses APPLICATION_HOST, not HOST in the production config" do
    expect(production_config).to match(/"APPLICATION_HOST"/)
    expect(production_config).not_to match(/"HOST"/)
  end

  it "configures email interceptor" do
    email_file = File.join(project_path, "config", "initializers", "email.rb")
    email_config = IO.read(email_file)

    expect(email_config).
      to include(%{RecipientInterceptor.new(ENV["EMAIL_RECIPIENTS"])})
  end

  it "configures language in html element" do
    layout_path = "/app/views/layouts/application.html.erb"
    layout_file = IO.read("#{project_path}#{layout_path}")
    expect(layout_file).to match(/<html lang="en">/)
  end

  it "configs active job queue adapter" do
    application_config = IO.read("#{project_path}/config/application.rb")

    expect(application_config).to match(
      /^ +config.active_job.queue_adapter = :delayed_job$/
    )
    expect(test_config).to match(
      /^ +config.active_job.queue_adapter = :inline$/
    )
  end

  it "configs background jobs for rspec" do
    delayed_job = IO.read("#{project_path}/bin/delayed_job")

    expect(delayed_job).to match(
      /^require 'delayed\/command'$/,
    )
  end

  it "configs bullet gem in development" do
    expect(development_config).to match /^ +Bullet.enable = true$/
    expect(development_config).to match /^ +Bullet.bullet_logger = true$/
    expect(development_config).to match /^ +Bullet.rails_logger = true$/
  end

  it "configs missing assets to raise in test" do
    expect(test_config).to match(
      /^ +config.assets.raise_runtime_errors = true$/,
    )
  end

  it "adds spring to binstubs" do
    expect(File).to exist("#{project_path}/bin/spring")

    bin_stubs = %w(rake rails rspec)
    bin_stubs.each do |bin_stub|
      expect(IO.read("#{project_path}/bin/#{bin_stub}")).to match(/spring/)
    end
  end

  it "removes comments and extra newlines from config files" do
    config_files = [
      IO.read("#{project_path}/config/application.rb"),
      IO.read("#{project_path}/config/environment.rb"),
      development_config,
      test_config,
      production_config,
    ]

    config_files.each do |file|
      expect(file).not_to match(%r{.*#.*})
      expect(file).not_to eq(file.strip)
      expect(file).not_to match(%r{^$\n\n})
    end
  end

  it "copies factories.rb" do
    expect(File).to exist("#{project_path}/spec/factories.rb")
  end

  it "creates review apps setup script" do
    bin_setup_path = "#{project_path}/bin/setup_review_app"
    bin_setup = IO.read(bin_setup_path)

    expect(bin_setup).to include("PARENT_APP_NAME=#{app_name.dasherize}-staging")
    expect(bin_setup).to include("APP_NAME=#{app_name.dasherize}-staging-pr-$1")
    expect(bin_setup).
      to include("heroku run rails db:migrate --exit-code --app $APP_NAME")
    expect(bin_setup).to include("heroku ps:scale worker=1 --app $APP_NAME")
    expect(bin_setup).to include("heroku restart --app $APP_NAME")

    expect("bin/setup_review_app").to be_executable
  end

  it "creates deploy script" do
    bin_deploy_path = "#{project_path}/bin/deploy"
    bin_deploy = IO.read(bin_deploy_path)

    expect(bin_deploy).to include("heroku run rails db:migrate --exit-code")
    expect("bin/deploy").to be_executable
  end

  it "creates heroku application manifest file with application name in it" do
    app_json_file = IO.read("#{project_path}/app.json")

    expect(app_json_file).to match(/"name":\s*"#{app_name.dasherize}"/)
  end

  def app_name
    SuspendersTestHelpers::APP_NAME
  end

  it "adds high_voltage" do
    gemfile = IO.read("#{project_path}/Gemfile")
    expect(gemfile).to match(/high_voltage/)
  end

  it "adds sassc-rails" do
    gemfile = read_project_file("Gemfile")

    expect(gemfile).to match(/sassc-rails/)
  end

  it "adds and configures bourbon" do
    gemfile = read_project_file("Gemfile")

    expect(gemfile).to match(/bourbon/)
  end

  it "configures bourbon, and bitters" do
    app_css = read_project_file(%w(app assets stylesheets application.scss))
    expect(app_css).to match(
      /normalize\.css\/normalize.*bourbon.*base/m,
    )
  end

  it "doesn't use turbolinks" do
    app_js = read_project_file(%w(app javascript packs application.js))
    expect(app_js).not_to match(/turbolinks/)
  end

  it "configures Timecop safe mode" do
    spec_helper = read_project_file(%w(spec spec_helper.rb))
    expect(spec_helper).to match(/Timecop.safe_mode = true/)
  end

  def development_config
    @_development_config ||=
      read_project_file %w(config environments development.rb)
  end

  def test_config
    @_test_config ||= read_project_file %w(config environments test.rb)
  end

  def production_config
    @_production_config ||=
      read_project_file %w(config environments production.rb)
  end

  def analytics_partial
    IO.read("#{project_path}/app/views/application/_analytics.html.erb")
  end

  def read_project_file(path)
    IO.read(File.join(project_path, *path))
  end
end
