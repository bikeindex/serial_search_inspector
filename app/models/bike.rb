class Bike < ApplicationRecord
  validates_presence_of :bike_index_id
  validates_uniqueness_of :bike_index_id

  has_and_belongs_to_many :serial_search
end
