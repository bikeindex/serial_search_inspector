class IpAddress < ApplicationRecord
  validates_presence_of :address

  has_many :log_lines
end
