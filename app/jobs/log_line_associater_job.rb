class LogLineAssociaterJob < ApplicationJob
  queue_as :default

  def perform
    LogLine.all.each do |log_line|
      log_line.find_or_create_ip_address_association
      log_line.find_or_create_serial_search_association
      log_line.save
      UpdateLastRequestAtJob.perform_later(log_line.serial_search, log_line.ip_address) if log_line.serial_search && log_line.ip_address
    end
  end
end
