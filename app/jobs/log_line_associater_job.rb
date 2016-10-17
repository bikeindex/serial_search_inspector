class LogLineAssociaterJob < ApplicationJob
  queue_as :default

  def perform
    LogLine.unprocessed.each do |log_line|
      log_line.find_or_create_ip_address_association
      log_line.find_or_create_serial_search_association
      log_line.save
      UpdateLastRequestAtJob.perform_later(log_line)
      BikeIndexRequestorJob.perform_later(log_line.serial_search) if log_line.serial_search
    end
  end
end
