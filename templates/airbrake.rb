if ENV.include?('AIRBRAKE_API_KEY')
  require 'airbrake'
  # Airbrake is an online tool that provides robust exception tracking in your Rails
  # applications. In doing so, it allows you to easily review errors, tie an error
  # to an individual piece of code, and trace the cause back to recent
  # changes. Airbrake enables for easy categorization, searching, and prioritization
  # of exceptions so that when errors occur, your team can quickly determine the
  # root cause.
  #
  # Configuration details:
  # https://github.com/airbrake/airbrake-ruby#configuration
  Airbrake.configure do |c|
    # You must set both project_id & project_key. To find your project_id and
    # project_key navigate to your project's General Settings and copy the values
    # from the right sidebar.
    # https://github.com/airbrake/airbrake-ruby#project_id--project_key
    c.project_id = ENV.fetch('AIRBRAKE_PROJECT_ID')
    c.project_key = ENV.fetch('AIRBRAKE_API_KEY')

    # Configures the root directory of your project. Expects a String or a
    # Pathname, which represents the path to your project. Providing this option
    # helps us to filter out repetitive data from backtrace frames and link to
    # GitHub files from our dashboard.
    # https://github.com/airbrake/airbrake-ruby#root_directory
    c.root_directory = Rails.root

    # By default, Airbrake Ruby outputs to STDOUT. In Rails apps it makes sense to
    # use the Rails' logger.
    # https://github.com/airbrake/airbrake-ruby#logger
    c.logger = Rails.logger

    # Configures the environment the application is running in. Helps the Airbrake
    # dashboard to distinguish between exceptions occurring in different
    # environments. By default, it's not set.
    # https://github.com/airbrake/airbrake-ruby#environment
    c.environment = Rails.env

    # Setting this option allows Airbrake to filter exceptions occurring in
    # unwanted environments such as :test. By default, it is equal to an empty
    # Array, which means Airbrake Ruby sends exceptions occurring in all
    # environments.
    # https://github.com/airbrake/airbrake-ruby#ignore_environments
    c.ignore_environments = %w(test)
  end

  # If Airbrake doesn't send any expected exceptions, we suggest to uncomment the
  # line below. It might simplify debugging of background Airbrake workers, which
  # can silently die.
  # Thread.abort_on_exception = ['test', 'development'].include?(Rails.env)
end
