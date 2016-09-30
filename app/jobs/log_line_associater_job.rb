class LogLineAssociaterJob < ApplicationJob
  queue_as :default

  def perform(log_line)
    log_line.find_or_create_ip_address_association
    log_line.find_or_create_serial_search_association
    log_line.save
  end
end
