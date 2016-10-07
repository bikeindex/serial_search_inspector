class IpAddress < ApplicationRecord
  validates_presence_of :address
  validates_uniqueness_of :address

  has_many :log_lines
  has_many :serial_searches, through: :log_lines

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      obj.city = geo.city
      obj.state = geo.state
      obj.country = geo.country_code
    end
  end

  after_validation :geocode, if: ->(obj) { obj.address.present? and obj.address_changed? }
  after_validation :reverse_geocode

  def location
    [city, state, country].join(', ')
  end

  def self.inspector_address?(address:, request_at:)
    where(address: address).each do |ip_address|
      if ip_address.started_being_inspector_at.present? && ip_address.started_being_inspector_at < request_at
        return true if ip_address.stopped_being_inspector_at.nil? || ip_address.stopped_being_inspector_at > request_at
      end
    end
    false
  end
end
