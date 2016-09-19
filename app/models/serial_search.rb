class SerialSearch < ApplicationRecord
  validates_presence_of :serial, :searched_bike_index_at
  validates_uniqueness_of :serial

  has_many :log_lines
  has_many :ip_addresses, through: :log_lines
  has_many :bike_index_bikes
end
