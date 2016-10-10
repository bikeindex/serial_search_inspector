class SerialSearch < ApplicationRecord
  validates_presence_of :serial
  validates_uniqueness_of :serial

  has_many :log_lines
  has_many :ip_addresses, through: :log_lines
  has_many :bike_index_bikes

  before_save :sanitize_serial

  scope :times_searched, -> { joins(:log_lines).count }

  def sanitize_serial
    self.serial = serial.strip.upcase
  end
end
