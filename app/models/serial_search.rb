class SerialSearch < ApplicationRecord
  validates_presence_of :serial
  validates_uniqueness_of :serial

  has_many :log_lines
  has_many :ip_addresses, through: :log_lines
  has_and_belongs_to_many :bikes, -> { distinct }

  before_save :sanitize_serial

  def within_min_request_time
    (searched_bike_index_at <= Time.now) && (searched_bike_index_at >= 8.hours.ago)
  end

  def self.sufficient_length
    4
  end

  def self.min_request_time
    8.hours.ago
  end

  def sanitize_serial
    self.serial = serial.strip.upcase
  end
end
