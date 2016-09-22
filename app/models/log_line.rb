class LogLine < ApplicationRecord
  validates_presence_of :entry, :request_at, :source, :type

  belongs_to :ip_address
  belongs_to :serial_search

  def serial?
    entry['params']['serial'].present? && !entry['params']['serial'].blank?
  end

  def attributes_from_entry
    {
      request_at: entry['@timestamp'],
      source: entry['??'],
      type: entry['format'],
      insufficient_length: check_length(),
      inspector_request: check_for_inspector_request,
      # entry_location: find_location(entry['remote_ip'])
    }
  end
end
