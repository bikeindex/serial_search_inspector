task associate_log_lines: :environment do
  # Sidekiq processes new logs too quickly and causes database failures
  LogLineAssociaterJob.perform_later
end

task reset_log_lines_counters: :environment do
  SerialSearch.find_each { |serial| SerialSearch.reset_counters(serial.id, :log_lines) }
  IpAddress.find_each { |ip| IpAddress.reset_counters(ip.id, :log_lines) }
end
