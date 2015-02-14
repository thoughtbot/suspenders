# https://devcenter.heroku.com/articles/rails-unicorn

worker_processes (ENV["UNICORN_WORKERS"] || 3).to_i
timeout (ENV["UNICORN_TIMEOUT"] || 15).to_i
preload_app true

before_fork do |_server, _worker|
  Signal.trap "TERM" do
    puts "Unicorn master intercepting TERM, sending myself QUIT instead"
    Process.kill "QUIT", Process.pid
  end
end

after_fork do |_server, _worker|
  Signal.trap "TERM" do
    puts "Unicorn worker intercepting TERM, waiting for master to send QUIT"
  end
end
