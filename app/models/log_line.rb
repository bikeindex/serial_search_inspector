class LogLine < ApplicationRecord
  validates_presence_of :entry, :request_at, :source, :serial

  belongs_to :ip_address, optional: true
  belongs_to :serial_search, optional: true

  def serial
    entry && entry['params'] && entry['params']['serial'] && entry['params']['serial'].strip
  end

  def find_location
    entry['params']['location'] if entry['params']['location'].present?
  end

  def find_source
    return 'html' if entry['path'] == '/bikes'
    entry['path'].match(/api\/v[^\/]+/i).to_s if entry['path'].include?('api')
  end

  def find_search_type
    if entry['params']['widget_from'].present?
      'widget'
    elsif entry['params']['multi_serial_search'].present?
      'multi'
    end
  end

  def find_request_at
    request_at || entry['@timestamp'] && Time.parse(entry['@timestamp'])
  end

  def serial_length_insufficient?
    entry['params']['serial'].length < 4 if serial
  end

  def inspector_request?
    IpAddress.inspector_address?(address: entry['remote_ip'], request_at: find_request_at)
  end

  def attributes_from_entry
    {
      request_at: find_request_at,
      source: find_source,
      search_type: find_search_type,
      insufficient_length: serial_length_insufficient?,
      inspector_request: inspector_request?,
      entry_location: find_location
    }
  end

  def self.create_log_line(entry)
    log_line = new(entry: entry)
    log_line.attributes = log_line.attributes_from_entry
    LogLine.first_or_create(log_line.attributes)
  end
end
