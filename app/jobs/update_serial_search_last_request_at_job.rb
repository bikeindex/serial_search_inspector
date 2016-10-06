class UpdateSerialSearchLastRequestAtJob < ApplicationJob
  queue_as :default

  def perform(serial_search)
    serial_search.log_lines.sort_by { |log_line| log_line.request_at }
    serial_search.update_attribute(:last_request_at, serial_search.log_lines[0].find_request_at)
  end
end
