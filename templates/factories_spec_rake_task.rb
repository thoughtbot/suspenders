if defined?(RSpec)
  desc 'Run factory specs.'

  RSpec::Core::RakeTask.new(:factory_specs) do |t|
    t.pattern = './spec/models/factories_spec.rb'
  end

  task spec: :factory_specs
end
