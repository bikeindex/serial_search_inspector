class BikeIndexBike < ApplicationRecord
  validates_presence_of :bike_index_id, :serial_search_id, :stolen
  validates_uniqueness_of :bike_index_id, :serial_search_id

  belongs_to :serial_search
end
