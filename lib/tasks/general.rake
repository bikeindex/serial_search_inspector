task :associate_log_lines => :environment do
  # Sidekiq processes new logs too quickly and causes database failures
  LogLine.find_each { |l| LogLineAssociaterJob.new.perform(l) }
end
