# :nocov:
if Rails.env.development?
  # Run annotate and erd tasks after db:migrate and db:rollback tasks
  Rake::Task['db:migrate'].enhance do
    Rake::Task['annotate'].invoke
    Rake::Task['erd'].invoke
    Rake::Task['db:test:prepare'].invoke
  end

  Rake::Task['db:rollback'].enhance do
    Rake::Task['annotate'].invoke
    Rake::Task['erd'].invoke
    Rake::Task['db:test:prepare'].invoke
  end
end
