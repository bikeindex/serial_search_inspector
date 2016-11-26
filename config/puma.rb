if ENV['STACK_PATH']
  stdout_redirect "#{ENV['STACK_PATH']}/log/production.log", "#{ENV['STACK_PATH']}/log/production.log", true
end