class IpAddress < ApplicationRecord
  validates_presence_of :address

  has_many :log_lines
  has_many :serial_searches, through: :log_lines
end
