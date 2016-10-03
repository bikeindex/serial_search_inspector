task :associate_log_lines => :environment do
  LogLine.find_each { |l| LogLineAssociaterJob.perform_later(l) }
end
