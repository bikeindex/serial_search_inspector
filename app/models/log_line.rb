class LogLine < ApplicationRecord
  validates_presence_of :entry, :request_at, :search_source, :serial

  belongs_to :ip_address, optional: true
  belongs_to :serial_search, optional: true

  scope :processed, -> { where.not(ip_address_id: nil) }
  scope :unprocessed, -> { where(ip_address_id: nil) }

  def serial
    entry && entry['params'] && entry['params']['serial'] && entry['params']['serial'].strip.upcase
  end

  def find_location
    entry['params']['location'] if entry['params']['location'].present?
  end

  def find_search_source
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
    serial.length < 4 if serial
  end

  def entry_ip_address
    entry['remote_ip']
  end

  def inspector_request?
    IpAddress.inspector_address?(address: entry_ip_address, request_at: find_request_at)
  end

  def attributes_from_entry
    {
      request_at: find_request_at,
      search_source: find_search_source,
      search_type: find_search_type,
      insufficient_length: serial_length_insufficient?,
      inspector_request: inspector_request?,
      entry_location: find_location
    }
  end

  def find_or_create_ip_address_association
    self.ip_address_id = IpAddress.find_or_create_by(address: entry_ip_address).id
  end

  def find_or_create_serial_search_association
    return false if serial_length_insufficient?
    serial_search = SerialSearch.find_or_create_by(serial: serial)
    serial_search.update_attribute(:searched_bike_index_at, find_request_at)
    self.serial_search_id = serial_search.id

  end

  def self.create_log_line(entry)
    log_line = new(entry: entry)
    where(request_at: log_line.find_request_at,
          search_source: log_line.find_search_source,
          search_type: log_line.find_search_type).each { |found| return true if log_line.serial == found.serial }
    log_line.update_attributes(log_line.attributes_from_entry)
    log_line
  end
end
