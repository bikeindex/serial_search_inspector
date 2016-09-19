class IpAddress < ApplicationRecord
  validates_presence_of :address

  belongs_to :log_line
end
