if ENV['COVERAGE'] && ENV['COVERAGE'].match?(/\Atrue\z/i)
  require 'cadre/simplecov'

  SimpleCov.start do
    add_filter '/.bundle/'
    add_filter '/spec/'
    add_filter '/config/'
    add_group 'Controllers', 'app/controllers'
    add_group 'Helpers',     'app/helpers'
    add_group 'Mailers',     'app/mailers'
    add_group 'Models',      'app/models'
    add_group 'Abilities',   'app/abilities'
    add_group 'Serializers', 'app/serializers'
    add_group 'Services',    'app/services'
    add_group 'Workers',     'app/workers'
    add_group 'Libraries',   'lib'
    add_group 'Long Files' do |src_file|
      src_file.lines.count > 300
    end
    add_group 'Ignored Code' do |src_file|
      File.readlines(src_file.filename).grep(/:nocov:/).any?
    end

    add_filter 'app/channels'
    add_filter 'lib/tasks'
    add_filter 'lib/seeder'
  end

  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    Cadre::SimpleCov::VimFormatter,
  ]

  SimpleCov.minimum_coverage 95
  SimpleCov.command_name 'Rspec'
end
