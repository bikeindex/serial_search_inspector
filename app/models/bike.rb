class Bike < ApplicationRecord
  validates_presence_of :bike_index_id, :serial_search_id, :stolen
  validates_uniqueness_of :bike_index_id, :serial_search_id

  has_and_belongs_to_many :serial_search
end
