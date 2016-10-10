class UpdateLastRequestAtJob < ApplicationJob
  queue_as :default

  def perform(serial_search, ip_address)
    serial_search.update_attribute(:last_request_at, serial_search.log_lines.maximum(:request_at))
    ip_address.update_attribute(:last_request_at, ip_address.log_lines.maximum(:request_at))
  end
end
