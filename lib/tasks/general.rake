task associate_log_lines: :environment do
  # Sidekiq processes new logs too quickly and causes database failures
  LogLineAssociaterJob.perform_later
end
