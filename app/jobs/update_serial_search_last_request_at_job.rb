class UpdateSerialSearchLastRequestAtJob < ApplicationJob
  queue_as :default

  def perform(serial_search)
    serial_search.update_attribute(:last_request_at, serial_search.log_lines.maximum(:request_at))
  end
end
