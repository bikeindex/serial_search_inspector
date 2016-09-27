class SerialSearch < ApplicationRecord
  validates_presence_of :serial
  validates_uniqueness_of :serial

  has_many :log_lines
  has_many :ip_addresses, through: :log_lines
  has_many :bike_index_bikes

  def sanitize_serial
    serial.strip!
    serial.capitalize!
  end
end
