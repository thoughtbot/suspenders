# :nocov:
if Rails.env.development?
  task :set_annotation_options do
    # Just some example settings from annotate 2.6.0.beta1
    Annotate.set_defaults(
      'position_in_routes'   => 'after',
      'position_in_class'    => 'after',
      'position_in_test'     => 'after',
      'position_in_fixture'  => 'after',
      'position_in_factory'  => 'after',
      'show_indexes'         => 'true',
      'simple_indexes'       => 'false',
      'model_dir'            => 'app/models',
      'include_version'      => 'false',
      'require'              => '',
      'exclude_tests'        => 'false',
      'exclude_fixtures'     => 'false',
      'exclude_factories'    => 'false',
      'ignore_model_sub_dir' => 'false',
      'skip_on_db_migrate'   => 'false',
      'format_bare'          => 'true',
      'format_rdoc'          => 'false',
      'format_markdown'      => 'false',
      'sort'                 => 'true',
      'force'                => 'false',
      'trace'                => 'false',
    )
  end

  # Annotate models
  task :annotate do
    puts 'Annotating models...'
    system 'bundle exec annotate -p after -i'
  end

  # Run annotate task after db:migrate and db:rollback tasks
  Rake::Task['db:migrate'].enhance do
    Rake::Task['annotate'].invoke
    Rake::Task['db:test:prepare'].invoke
  end

  Rake::Task['db:rollback'].enhance do
    Rake::Task['annotate'].invoke
    Rake::Task['db:test:prepare'].invoke
  end
end
