module BackgroundJobs
  def run_background_jobs_immediately
    delay_jobs = Delayed::Worker.delay_jobs
    Delayed::Worker.delay_jobs = false
    yield
  ensure
    Delayed::Worker.delay_jobs = delay_jobs
  end
end
