class IpAddress < ApplicationRecord
  validates_presence_of :address
  validates_uniqueness_of :address

  has_many :log_lines
  has_many :serial_searches, through: :log_lines

  geocoded_by :address
  after_validation :geocode, if: ->(obj) { obj.address.present? and obj.address_changed? }

  def self.inspector_address?(address:, request_at:)
    where(address: address).each do |ip|
      if ip.started_being_inspector_at < request_at
        return true if ip.stopped_being_inspector_at.nil? || ip.stopped_being_inspector_at > request_at
      end
    end
    false
  end
end
