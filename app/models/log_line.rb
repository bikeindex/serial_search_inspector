class LogLine < ApplicationRecord
  validates_presence_of :entry, :request_at, :source

  belongs_to :ip_address, optional: true
  belongs_to :serial_search, optional: true

  def serial?
    entry['params']['serial'].present? && !entry['params']['serial'].blank?
  end

  def find_location
    entry['params']['location'] if entry['params']['location'].present?
  end

  def find_source
    return 'html' if entry['path'] == '/bikes'
    if entry['path'].include?('api')
      m = entry['path'].match(/api\/v[^\/]+/i)
      m.to_s
    end
  end

  def find_type
    if entry['params']['widget_from'].present?
      'widget'
    elsif entry['params']['multi_serial_search'].present?
      'multi'
    end
  end

  def find_request_at
    request_at || Time.parse(entry['@timestamp'])
  end

  def check_length
    return true if entry['params']['serial'].length <= 3
    return false if entry['params']['serial'].length > 3
  end

  def inspector_request?
    IpAddress.inspector_address?(address: entry['remote_ip'], request_at: find_request_at)
  end

  def attributes_from_entry
    {
      request_at: find_request_at,
      source: find_source,
      type: find_type,
      insufficient_length: check_length,
      inspector_request: inspector_request?,
      entry_location: find_location
    }
  end

  def self.create_log_line(entry)
    log_line = new(entry: entry)
    if log_line.serial?
      log_line.update_attributes(log_line.attributes_from_entry)
      log_line.save
    end
  end
end
