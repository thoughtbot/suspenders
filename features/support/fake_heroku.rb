class FakeHeroku
  RECORDER = File.expand_path(File.join('..', '..', 'tmp', 'heroku_commands'), File.dirname(__FILE__))

  def initialize(args)
    @args = args
  end

  def run!
    File.open(RECORDER, 'a') do |file|
      file.write @args.join(' ')
    end
  end

  def self.clear!
    FileUtils.rm_rf RECORDER
  end

  def self.has_created_app?(app_name)
    File.open(RECORDER, 'r').read.include?("create #{app_name}")
  end
end
