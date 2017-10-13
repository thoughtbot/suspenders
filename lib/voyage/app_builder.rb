module Suspenders
  class AppBuilder < Rails::AppBuilder
    def agree?(prompt)
      puts prompt
      response = STDIN.gets.chomp

      response.empty? || %w(y yes).include?(response.downcase.strip)
    end

    def accept_defaults
      if agree?('Would you like to accept all defaults? [slim, devise w/ first & last name] (Y/n)')
        @@accept_defaults = true
      else
        @@accept_defaults = false
      end
    end

    def update_gemset_in_gemfile
      replace_in_file 'Gemfile', '#ruby-gemset', "#ruby-gemset=#{app_name}"

      # Remove commented out lines from template
      gsub_file('Gemfile', /^\s{2}\n/, '')
    end

    def bundle_without_production
      template '../templates/bundle_config', '.bundle/config'
    end

    def use_slim
      if @@accept_defaults || agree?('Would you like to use slim? (Y/n)')
        @@use_slim = true
        run 'gem install html2slim'
        update_application_rb_for_slim
      else
        @@use_slim = false
        gsub_file('Gemfile', /^gem 'slim-rails'\n/, '')
      end
    end

    def update_application_layout_for_slim
      find = <<-RUBY.gsub(/^ {4}/, '')
        <%#
          Configure default and controller-, and view-specific titles in
          config/locales/en.yml. For more see:
          https://github.com/calebthompson/title#usage
        %>
      RUBY

      replace = <<-RUBY.gsub(/^ {8}/, '')
          <% # Configure default and controller-, and view-specific titles in
        # config/locales/en.yml. For more see:
        # https://github.com/calebthompson/title#usage %>
      RUBY

      replace_in_file 'app/views/layouts/application.html.erb', find, replace

      inside('lib') do # arbitrary, run in context of newly generated app
        run "erb2slim '../app/views/layouts' '../app/views/layouts'"
        run "erb2slim -d '../app/views/layouts'"
      end

      # strip trailing space after closing "> in application layout before
      # trying to find and replace it
      replace_in_file 'app/views/layouts/application.html.slim', '| "> ', '| ">'

      find = <<-RUBY.gsub(/^ {6}/, '')
        |  <body class="
        = devise_controller? ? 'devise' : 'application'
        = body_class
        | ">
      RUBY

      replace = <<-RUBY.gsub(/^ {6}/, '')
        body class="\#{devise_controller? ? 'devise' : 'application'} \#{body_class}"
      RUBY

      replace_in_file 'app/views/layouts/application.html.slim', find, replace
    end

    def update_application_rb_for_slim
      inject_into_file "config/application.rb", after: "     g.fixture_replacement :factory_girl, dir: 'spec/factories'\n" do <<-'RUBY'.gsub(/^ {2}/, '')
        g.template_engine :slim
        RUBY
      end
    end

    # ------------
    # DEVISE SETUP
    # ------------
    def install_devise
      if @@accept_defaults || agree?('Would you like to install Devise? (Y/n)')
        @@use_devise = true

        if @@accept_defaults || agree?('Would you like to install Devise token authentication? (Y/n)')
          devise_token_auth = true
        end

        bundle_command 'exec rails generate devise:install'

        if @@accept_defaults || agree?("Would you like to add first_name and last_name to the devise model? (Y/n)")
          adding_first_and_last_name = true

          bundle_command "exec rails generate resource user first_name:string last_name:string uuid:string"

          replace_in_file 'spec/factories/users.rb',
            'first_name "MyString"', 'first_name { Faker::Name.first_name }'
          replace_in_file 'spec/factories/users.rb',
            'last_name "MyString"', 'last_name { Faker::Name.last_name }'
          replace_in_file 'spec/factories/users.rb',
            'uuid "MyString"', 'uuid { SecureRandom.uuid }'
        end

        bundle_command "exec rails generate devise user"
        bundle_command 'exec rails generate devise:views'

        if @@use_slim
          inside('lib') do # arbitrary, run in context of newly generated app
            run "erb2slim '../app/views/devise' '../app/views/devise'"
            run "erb2slim -d '../app/views/devise'"
          end
        end

        customize_devise_views if adding_first_and_last_name
        customize_application_controller_for_devise(adding_first_and_last_name, devise_token_auth)
        add_devise_registrations_controller
        customize_resource_controller_for_devise(adding_first_and_last_name)
        add_admin_views_for_devise_resource(adding_first_and_last_name)
        add_analytics_initializer
        authorize_devise_resource_for_index_action
        add_canard_roles_to_devise_resource
        update_devise_initializer
        add_custom_routes_for_devise
        customize_user_factory(adding_first_and_last_name)
        generate_seeder_templates(using_devise: true)
        customize_user_spec
        add_token_auth
      else
        @@use_devise = false
        generate_seeder_templates(using_devise: false)
      end
    end

    def customize_devise_views
      %w(edit new).each do |file|
        if @@use_slim
          file_path = "app/views/devise/registrations/#{file}.html.slim"
          inject_into_file file_path, before: "    = f.input :email, required: true, autofocus: true" do <<-'RUBY'.gsub(/^ {8}/, '')
            = f.input :first_name, required: true, autofocus: true
            = f.input :last_name, required: true
            RUBY
          end
        else
          file_path = "app/views/devise/registrations/#{file}.html.erb"
          inject_into_file file_path, before: "    <%= f.input :email, required: true, autofocus: true %>" do <<-'RUBY'.gsub(/^ {8}/, '')
            <%= f.input :first_name, required: true, autofocus: true %>
            <%= f.input :last_name, required: true %>
            RUBY
          end
        end
      end
    end

    def customize_application_controller_for_devise(adding_first_and_last_name, devise_token_auth)
      inject_into_file 'app/controllers/application_controller.rb', before: "class ApplicationController < ActionController::Base" do <<-RUBY.gsub(/^ {8}/, '')
        # rubocop:disable Metrics/ClassLength, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/LineLength
        RUBY
      end

      inject_into_file 'app/controllers/application_controller.rb', after: "  protect_from_forgery with: :exception" do <<-RUBY.gsub(/^ {6}/, '')

        check_authorization unless: :devise_or_pages_controller?
        impersonates :user
        #{'acts_as_token_authentication_handler_for User' if devise_token_auth}

        before_action :configure_permitted_parameters, if: :devise_controller?
        before_action :authenticate_user!, unless: -> { is_a?(HighVoltage::PagesController) }
        before_action :add_layout_name_to_gon
        before_action :detect_device_type

        rescue_from CanCan::AccessDenied do |exception|
          redirect_to root_path, alert: exception.message
        end

        # Example Traditional Event: analytics_track(user, 'Created Widget', { widget_name: 'foo' })
        # Example Page View:         analytics_track(user, 'Page Viewed', { page_name: 'Terms and Conditions', url: '/terms' })
        #
        # NOTE: setup some defaults that we want to track on every event mixpanel_track
        # NOTE: the identify step happens on every page load to keep intercom.io and mixpanel people up to date
        def analytics_track(user, event_name, options = {})
          return if user.tester?

          sanitized_options = sanitize_hash_javascript(options)

          segment_attributes = {
            user_id: user.uuid,
            event: event_name,
            properties: {
              browser:         "\#{browser.name rescue 'unknown'}",
              browser_id:      "\#{browser.id rescue 'unknown'}",
              browser_version: "\#{browser.version rescue 'unknown'}",
              platform:        "\#{browser.platform rescue 'unknown'}",
              roles:           "\#{user.roles.map(&:to_s).join(',') rescue ''}",
              rails_env:       Rails.env.to_s,
            }.merge(sanitized_options),
          }

          Analytics.track(segment_attributes)
        end

        protected

        def devise_or_pages_controller?
          devise_controller? == true || is_a?(HighVoltage::PagesController)
        end

        def sanitize_hash_javascript(hash)
          hash.deep_stringify_keys
              .deep_transform_keys { |k| sanitize_javascript(k) }
              .transform_values    { |v| sanitize_javascript(v) }
        end

        def sanitize_javascript(value)
          value.is_a?(String) ? ActionView::Base.new.escape_javascript(value) : value
        end

        def configure_permitted_parameters
          devise_parameter_sanitizer.permit(
            :sign_up,
            keys: [
              #{':first_name,' if adding_first_and_last_name}
              #{':last_name,' if adding_first_and_last_name}
              :email,
              :password,
              :password_confirmation,
              :remember_me,
            ],
          )

          devise_parameter_sanitizer.permit(
            :sign_in,
            keys: [
              :login, :email, :password, :remember_me
            ],
          )

          devise_parameter_sanitizer.permit(
            :account_update,
            keys: [
              #{':first_name,' if adding_first_and_last_name}
              #{':last_name,' if adding_first_and_last_name}
              :email,
              :password,
              :password_confirmation,
              :current_password,
            ],
          )
        end

        def add_layout_name_to_gon
          gon.layout =
            case devise_controller?
            when true
              'devise'
            else
              'application'
            end
        end

        def detect_device_type
          request.variant =
            case request.user_agent
            when /iPad/i
              :tablet
            when /iPhone/i
              :phone
            when /Android/i && /mobile/i
              :phone
            when /Android/i
              :tablet
            when /Windows Phone/i
              :phone
            end
        end
        RUBY
      end
    end

    def add_devise_registrations_controller
      template '../templates/devise_registrations_controller.rb',
               'app/controllers/devise_customizations/registrations_controller.rb'
    end


    def add_analytics_initializer
      template '../templates/analytics_ruby_initializer.rb', 'config/initializers/analytics_ruby.rb'
      template '../templates/analytics_alias.html.erb.erb', 'app/views/users/analytics_alias.html.erb'
    end

    def customize_resource_controller_for_devise(adding_first_and_last_name)
      bundle_command 'exec rails generate controller users'
      run 'rm spec/controllers/users_controller_spec.rb'

      inject_into_class 'app/controllers/users_controller.rb', 'UsersController' do <<-RUBY.gsub(/^ {6}/, '')
        # https://github.com/CanCanCommunity/cancancan/wiki/authorizing-controller-actions
        # load_and_authorize_resource only: []
        skip_authorization_check only: [:analytics_alias]

        def analytics_alias
          # view file has JS that will identify the anonymous user through segment
          # after registration via "after devise registration path"
        end
        RUBY
      end
    end

    def add_admin_views_for_devise_resource(adding_first_and_last_name)
      config = { adding_first_and_last_name: adding_first_and_last_name }
      template '../templates/users_index.html.erb', 'app/views/admin/users/index.html.erb', config

      if @@use_slim
        inside('lib') do # arbitrary, run in context of newly generated app
          run "erb2slim '../app/views/users' '../app/views/users'"
          run "erb2slim -d '../app/views/users'"

          run "erb2slim '../app/views/admin/users' '../app/views/admin/users'"
          run "erb2slim -d '../app/views/admin/users'"
        end
      end

      # FIXME: (2017-06-04) jon => make these relevant
      template '../templates/admin_users_controller.rb', 'app/controllers/admin/users_controller.rb'
      template '../templates/admin_controller.rb', 'app/controllers/admin/admin_controller.rb'
    end

    def authorize_devise_resource_for_index_action
      generate 'canard:ability user can:manage:user cannot:destroy:user'
      generate 'canard:ability admin can:destroy:user'

      %w(admins users).each do |resource_name|
        replace_in_file "spec/abilities/#{resource_name}_spec.rb", "require 'cancan/matchers'", "require_relative '../support/matchers/custom_cancan'"
      end

      find = <<-RUBY.gsub(/^ {4}/, '')
        it { is_expected.to be_able_to(:manage, user) }
      RUBY
      replace = <<-RUBY.gsub(/^ {4}/, '')
        it { is_expected.to be_able_to(:manage, acting_user) }
        it { is_expected.to_not be_able_to(:manage, user) }
      RUBY
      replace_in_file 'spec/abilities/users_spec.rb', find, replace

      find = <<-RUBY.gsub(/^ {6}/, '')
        can [:manage], User
      RUBY
      replace = <<-RUBY.gsub(/^ {6}/, '')
        can [:manage], User do |u|
          u == user
        end
      RUBY
      replace_in_file 'app/abilities/users.rb', find, replace

      generate 'migration add_roles_mask_to_users roles_mask:integer'
      template '../templates/custom_cancan_matchers.rb', 'spec/support/matchers/custom_cancan.rb'
    end

    def add_canard_roles_to_devise_resource
      inject_into_file 'app/models/user.rb', before: /^end/ do <<-RUBY.gsub(/^ {6}/, '')

        before_create :generate_uuid

        # Permissions cascade/inherit through the roles listed below. The order of
        # this list is important, it should progress from least to most privelage
        ROLES = [:admin].freeze
        acts_as_user roles: ROLES
        roles ROLES

        validates :email,
                  presence: true,
                  format: /\\A[-a-z0-9_+\\.]+\\@([-a-z0-9]+\\.)+[a-z0-9]{2,8}\\z/i,
                  uniqueness: true

        # NOTE: these password validations won't run if the user has an invite token
        validates :password,
                  presence: true,
                  length: { within: 8..72 },
                  confirmation: true,
                  on: :create
        validates :password_confirmation,
                  presence: true,
                  on: :create

        def tester?
          (email =~ /(example.com|headway.io)$/).present?
        end

        private

        def generate_uuid
          loop do
            uuid = SecureRandom.uuid
            self.uuid = uuid
            break unless User.exists?(uuid: uuid)
          end
        end
        RUBY
      end
    end

    def update_devise_initializer
      replace_in_file 'config/initializers/devise.rb',
        'config.sign_out_via = :delete', 'config.sign_out_via = :get'

      replace_in_file 'config/initializers/devise.rb',
        "config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'",
        "config.mailer_sender = 'user@example.com'"
    end

    def add_custom_routes_for_devise
      find = <<-RUBY.gsub(/^ {6}/, '')
        devise_for :users
        resources :users
      RUBY

      replace = <<-RUBY.gsub(/^ {6}/, '')
        devise_for :users, controllers: {
          registrations: 'devise_customizations/registrations',
        }

        resources :users do
          member do
            get 'analytics_alias'
          end
        end

        namespace :admin do
          resources :users do
            member do
              get 'impersonate'
            end

            collection do
              get 'stop_impersonating'
            end
          end
        end

        authenticated :user do
          # root to: 'dashboard#show', as: :authenticated_root
          root to: 'high_voltage/pages#show', id: 'welcome', as: :authenticated_root
        end

        devise_scope :user do
          get 'sign-in',  to: 'devise/sessions#new'
          get 'sign-out', to: 'devise/sessions#destroy'
        end
      RUBY

      replace_in_file 'config/routes.rb', find, replace
    end

    def customize_user_factory(adding_first_and_last_name)
      inject_into_file 'spec/factories/users.rb', before: /^  end/ do <<-'RUBY'.gsub(/^ {4}/, '')
        password 'asdfjkl123'
        password_confirmation 'asdfjkl123'
        sequence(:email) { |n| "user_#{n}@example.com" }

        trait :admin do
          roles [:admin]
          email 'admin@example.com'
        end
        RUBY
      end

      if adding_first_and_last_name
        inject_into_file 'spec/factories/users.rb', after: /roles \[:admin\]\n/ do <<-'RUBY'.gsub(/^ {4}/, '')
          first_name 'Admin'
          last_name 'User'
          RUBY
        end
      end
    end
    # ----------------
    # END DEVISE SETUP
    # ----------------

    def generate_seeder_templates(using_devise:)
      config = { force: true, using_devise: using_devise }
      template '../templates/seeder.rb.erb', 'lib/seeder.rb', config
      template '../templates/seeds.rb.erb', 'db/seeds.rb', config
    end

    def customize_user_spec
      find = <<-RUBY.gsub(/^ {6}/, '')
        pending "add some examples to (or delete) \#{__FILE__}"
      RUBY

      replace = <<-RUBY.gsub(/^ {6}/, '')
        describe 'constants' do
          context 'roles' do
            it 'has the admin role' do
              expect(User::ROLES).to eq([:admin])
            end
          end
        end

        describe 'validations' do
          it { is_expected.to validate_presence_of(:email) }
          it { is_expected.to validate_presence_of(:password) }
          it { is_expected.to validate_presence_of(:password_confirmation) }
        end

        context '#tester?' do
          ['example.com', 'headway.io'].each do |domain|
            it "an email including the \#{domain} domain is a tester" do
              user = build(:user, email: "asdf@\#{domain}")
              expect(user.tester?).to eq(true)
            end
          end

          it 'an email including the gmail.com domain is NOT a tester' do
            user = build(:user, email: 'asdf@gmail.com')
            expect(user.tester?).to eq(false)
          end
        end

        context 'new user creation' do
          it 'ensures uniqueness of the uuid' do
            allow(User).to receive(:exists?).and_return(true, false)

            expect do
              create(:user)
            end.to change { User.count }.by(1)

            expect(User).to have_received(:exists?).exactly(2).times
          end
        end
      RUBY

      replace_in_file 'spec/models/user_spec.rb', find, replace
    end

    # FIXME: (2017-06-04) jon => make this use tiddle
    def add_token_auth
      inject_into_file 'app/models/user.rb', after: "class User < ApplicationRecord" do <<-'RUBY'.gsub(/^ {6}/, '')

        acts_as_token_authenticatable
        RUBY
      end

      generate 'migration add_authentication_token_to_users "authentication_token:string{30}:uniq"'

      # specs
      template '../templates/specs/features/user_impersonation_spec.rb', 'spec/features/user_impersonation_spec.rb', force: true
      template '../templates/specs/features/user_list_spec.rb', 'spec/features/user_list_spec.rb', force: true
      template '../templates/specs/features/user_signup_spec.rb', 'spec/features/user_signup_spec.rb', force: true
      template '../templates/specs/requests/user_api_spec.rb', 'spec/requests/user_api_spec.rb', force: true
      template '../templates/specs/support/api/schemas/user.json', 'spec/support/api/schemas/user.json', force: true
      template '../templates/config_initializers_ams.rb', 'config/initializers/ams.rb', force: true
      template '../templates/specs/support/matchers/api_schema_matcher.rb', 'spec/support/matchers/api_schema_matcher.rb', force: true
      template '../templates/specs/mailers/application_mailer_spec.rb.erb', 'spec/mailers/application_mailer_spec.rb', force: true
      template '../templates/specs/support/features/session_helpers.rb', 'spec/support/features/session_helpers.rb', force: true
      template '../templates/specs/support/request_spec_helper.rb', 'spec/support/request_spec_helper.rb', force: true
    end

    def add_api_foundation
      # Create /app/api/base_api_controller.rb
      template '../templates/api_base_controller.rb', 'app/controllers/api/base_api_controller.rb', force: true

      # Create /app/api/v1/users_controller.rb
      template '../templates/api_users_controller.rb', 'app/controllers/api/v1/users_controller.rb', force: true

      # Update routes to include namespaced API
      inject_into_file 'config/routes.rb', before: /^end/ do <<-RUBY.gsub(/^ {6}/, '')

        # API-specific routes
        namespace 'api' do
          namespace 'v1' do
            resources :users, except: [:new, :edit]
          end
        end
        RUBY
      end
    end

    def customize_application_js
      template '../templates/application.js', 'app/assets/javascripts/application.js', force: true

      template '../templates/app_name.js', "app/assets/javascripts/#{app_name}.js", force: true
      inject_into_file 'app/assets/javascripts/application.js', after: '//= require foundation' do <<-RUBY.gsub(/^ {8}/, '')

        //= require #{app_name}
      RUBY
      end

      inject_into_file 'app/views/application/_javascript.html.erb', after: '<%= render "analytics" %>' do <<-RUBY.gsub(/^ {8}/, '')

        <%= render "analytics_identify" %>
      RUBY
      end
    end

    def require_files_in_lib
      create_file 'config/initializers/require_files_in_lib.rb' do <<-RUBY.gsub(/^ {8}/, '')
        # rubocop:disable Rails/FilePath
        Dir[File.join(Rails.root, 'lib', '**', '*.rb')].each { |l| require l }
        # rubocop:enable Rails/FilePath
        RUBY
      end
    end

    def generate_ruby_version_and_gemset
      create_file '.ruby-gemset', "#{app_name}\n"
    end

    def generate_data_migrations
      generate 'data_migrations:install'

      file = Dir['db/migrate/*_create_data_migrations.rb'].first
      replace_in_file file, 'class CreateDataMigrations < ActiveRecord::Migration', "class CreateDataMigrations < ActiveRecord::Migration[4.2]"

      empty_directory_with_keep_file 'db/data_migrate'
    end

    def add_high_voltage_static_pages
      template '../templates/about.html.erb', "app/views/pages/about.html.#{@@use_slim ? 'slim' : 'erb'}"
      template '../templates/welcome.html.erb', "app/views/pages/welcome.html.erb"

      inject_into_file 'config/routes.rb', before: /^end/ do <<-RUBY.gsub(/^ {6}/, '')
        root 'high_voltage/pages#show', id: 'welcome'
        RUBY
      end

      create_file 'config/initializers/high_voltage.rb' do <<-RUBY.gsub(/^ {8}/, '')
        HighVoltage.configure do |config|
          config.route_drawer = HighVoltage::RouteDrawers::Root
        end
        RUBY
      end
    end

    # TODO: (2017-06-04) jon => make this relevant
    def add_app_css_file
      bundle_command 'exec rails generate foundation:install --skip'

      run 'rm -f app/views/layouts/foundation_layout.html.slim'

      create_file "app/assets/stylesheets/#{app_name}.scss" do <<-RUBY.gsub(/^ {8}/, '')
        //We can add some default styles here in voyage

        //Figure out what foundations visual grid settings are and turn them on here
        //$visual-grid: true;
        //$visual-grid-color: #9cf !default;
        //$visual-grid-index: front !default;
        //$visual-grid-opacity: 0.1 !default;
        .main { margin: 10px 30px; }
        RUBY
      end

      inject_into_file 'app/assets/stylesheets/application.scss', after: '@import "refills/flashes";'  do <<-RUBY.gsub(/^ {8}/, '')
        \n@import "#{app_name}";
        RUBY
      end
    end

    def add_navigation_and_footer
      template '../templates/navigation.html.erb', 'app/views/components/_navigation.html.erb', force: true
      template '../templates/footer.html.erb', 'app/views/components/_footer.html.erb', force: true
    end

    def generate_test_environment
      template '../templates/controller_helpers.rb', 'spec/support/controller_helpers.rb'
      template '../templates/simplecov.rb', '.simplecov'
    end

    def update_test_environment
      inject_into_file 'spec/support/factory_girl.rb', before: /^end/ do <<-RUBY.gsub(/^ {6}/, '')

        # Spring doesn't reload factory_girl
        config.before(:all) do
          FactoryGirl.reload
        end
        RUBY
      end

      template "../templates/rails_helper.rb.erb", "spec/rails_helper.rb", force: true

      # NOTE: (2017-06-04) jon => Comment out for now...this seems to break administrate
      # %w(test development).each do |environment|
      #   inject_into_file "config/environments/#{environment}.rb", after: /^end/ do <<-RUBY.gsub(/^ {10}/, '')

      #     # NOTE: console can use create(:factory_name), or build(:factory_name) without
      #     # needing to use FactoryGirl.create(:factory_name).
      #     include FactoryGirl::Syntax::Methods
      #     RUBY
      #   end
      # end
    end

    def add_rubocop_config
      template '../templates/rubocop.yml', '.rubocop.yml', force: true
    end

    def add_auto_annotate_models_rake_task
      template '../templates/auto_annotate_models.rake', 'lib/tasks/auto_annotate_models.rake', force: true
    end

    def add_favicon
      template '../templates/favicon.ico', 'app/assets/images/favicon.ico', force: true
    end

    def customize_application_mailer
      template '../templates/application_mailer.rb.erb', 'app/mailers/application_mailer.rb', force: true
    end

    def add_specs
      inject_into_file 'app/jobs/application_job.rb', before: "class ApplicationJob < ActiveJob::Base" do <<-RUBY.gsub(/^ {8}/, '')
        # :nocov:
        RUBY
      end

      template '../templates/specs/controllers/admin/users_controller_spec.rb', 'spec/controllers/admin/users_controller_spec.rb', force: true
      template '../templates/specs/controllers/application_controller_spec.rb', 'spec/controllers/application_controller_spec.rb', force: true
    end

    # Do this last
    def rake_db_setup
      rake 'db:migrate'
      rake 'db:seed' if File.exist?('config/initializers/devise.rb')
    end

    def configure_rvm_prepend_bin_to_path
      run "rm -f $rvm_path/hooks/after_cd_bundler"

      run "touch $rvm_path/hooks/after_cd_bundler"

      git_safe_dir = <<-RUBY.gsub(/^ {8}/, '')
        #!/usr/bin/env bash
        export PATH=".git/safe/../../bin:$PATH"
        RUBY

      run "echo '#{git_safe_dir}' >> $rvm_path/hooks/after_cd_bundler"

      run 'chmod +x $rvm_path/hooks/after_cd_bundler'

      run 'mkdir -p .git/safe'
    end

    def run_rubocop_auto_correct
      run 'rubocop --auto-correct'
    end

    def copy_env_to_example
      run 'cp .env .env.example'
    end

    def add_to_gitignore
      inject_into_file '.gitignore', after: '/tmp/*' do <<-RUBY.gsub(/^ {8}/, '')

        .env
        .zenflow-log
        errors.err
        .ctags
        .cadre/coverage.vim
        RUBY
      end
    end

    def spin_up_webpacker
      rake 'webpacker:install'
      rake 'webpacker:install:react'
    end

    ###############################
    # OVERRIDE SUSPENDERS METHODS #
    ###############################
    def configure_generators
      config = <<-RUBY.gsub(/^ {4}/, '')

        config.generators do |g|
          g.helper false
          g.javascript_engine false
          g.request_specs false
          g.routing_specs false
          g.stylesheets false
          g.test_framework :rspec
          g.view_specs false
          g.fixture_replacement :factory_girl, dir: 'spec/factories'
        end

      RUBY

      inject_into_class 'config/application.rb', 'Application', config
    end

    def set_ruby_to_version_being_used
      create_file '.ruby-version', "#{Voyage::RUBY_VERSION}\n"
    end

    def overwrite_application_layout
      template '../templates/voyage_layout.html.erb.erb', 'app/views/layouts/application.html.erb', force: true
      update_application_layout_for_slim if @@use_slim

      template '../templates/analytics_identify.html.erb.erb', 'app/views/application/_analytics_identify.html.erb', force: true
    end

    def create_database
      # Suspenders version also migrates, we don't want that yet... we migrate in the rake_db_setup method
      bundle_command 'exec rake db:create'
    end

    # --------------------------------
    # setup_test_environment overrides
    # --------------------------------
    def generate_factories_file
      # NOTE: (2016-02-03) jonk => don't want this, we use individual factories
    end

    def configure_ci
      template "../templates/circle.yml.erb", "circle.yml"
    end

    def configure_background_jobs_for_rspec
      # NOTE: (2017-05-31) jon => don't want this
    end

    def configure_active_job
      # NOTE: (2017-06-02) jon => don't want this
    end

    def configure_capybara_webkit
      # NOTE: (2016-02-03) jonk => don't want this
    end
    # ------------------------------------
    # End setup_test_environment overrides
    # ------------------------------------

    def remove_config_comment_lines
      # NOTE: (2016-02-09) jonk => don't want this
    end
  end
end
