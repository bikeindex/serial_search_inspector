class IpAddress < ApplicationRecord
  validates_presence_of :address
  validates_uniqueness_of :address

  has_many :log_lines
  has_many :serial_searches, through: :log_lines

  geocoded_by :address
  after_validation :geocode # , if: ->(obj){ obj.address.present? and obj?.address_changed? }

  def self.currently_inspector?(ip, request_at)
    ip.started_being_inspector_at < request_at && ip.stopped_being_inspector_at.nil?
  end

  def self.past_inspector?(ip, request_at)
    ip.started_being_inspector_at < request_at && ip.stopped_being_inspector_at > request_at
  end

  def self.inspector_address?(address:, request_at:)
    where(address: address).each do |ip|
      if currently_inspector?(ip, request_at)
        return true
      elsif past_inspector?(ip, request_at)
        return true
      end
    end
    false
  end

  # Check that it's after the start - and before the end if there is an end
  # - Current inspector has no end date
end
