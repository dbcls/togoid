worker_processes Integer(ENV['WEB_CONCURRENCY'] || 8)

pid File.expand_path('../../tmp/pids/unicorn.pid', __FILE__)

stdout_path File.expand_path('../../log/unicorn_stdout.log', __FILE__)
stderr_path File.expand_path('../../log/unicorn_stderr.log', __FILE__)

preload_app true

timeout 30
