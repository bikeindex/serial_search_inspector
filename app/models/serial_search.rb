class SerialSearch < ApplicationRecord
  validates_presence_of :serial
  validates_uniqueness_of :serial

  has_many :log_lines
  has_many :ip_addresses, through: :log_lines
  has_and_belongs_to_many :bikes

  before_save :sanitize_serial

  def sanitize_serial
    self.serial = serial.strip.upcase
  end
end
