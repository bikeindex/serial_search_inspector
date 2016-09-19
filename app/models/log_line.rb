class LogLine < ApplicationRecord
  validates_presence_of :entry, :request_at, :source, :type

  belongs_to :ip_address
  belongs_to :serial_search
end
