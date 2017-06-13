class SerialSearch < ApplicationRecord
  validates_presence_of :serial
  validates_uniqueness_of :serial

  include PgSearch
  pg_search_scope :search_by_serial_number, against: :serial

  has_many :log_lines
  has_many :ip_addresses, through: :log_lines
  has_many :bike_serial_searches
  has_many :bikes, -> { distinct }, through: :bike_serial_searches

  before_save :sanitize_serial

  def valid_serial_search_for_bike_creation?
    searched_bike_index_at.nil? || !within_min_request_time
  end

  def within_min_request_time
    (searched_bike_index_at <= Time.now) && (searched_bike_index_at >= SerialSearch.min_request_time)
  end

  def self.sufficient_length
    4
  end

  def self.min_request_time
    8.hours.ago
  end

  def self.text_search(query)
    if query.present?
      search_by_serial_number(query)
    else
      all
    end
  end

  def sanitize_serial
    self.serial = serial.strip.upcase
  end
end
