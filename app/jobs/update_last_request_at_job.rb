class UpdateLastRequestAtJob < ApplicationJob
  queue_as :default

  def perform(log_line)
    if log_line.serial_search
      log_line.serial_search.update_attribute(:last_request_at, log_line.serial_search.log_lines.maximum(:request_at))
    end
    if log_line.ip_address
      log_line.ip_address.update_attribute(:last_request_at, log_line.ip_address.log_lines.maximum(:request_at))
    end
  end
end
