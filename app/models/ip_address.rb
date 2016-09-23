class IpAddress < ApplicationRecord
  validates_presence_of :address

  has_many :log_lines
  has_many :serial_searches, through: :log_lines

  def self.inspector_address?(address:, request_at:)
  end

  # Check that it's after the start - and before the end if there is an end
  # - Current inspector has no end date
end
