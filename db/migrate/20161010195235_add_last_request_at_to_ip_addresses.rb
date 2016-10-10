class AddLastRequestAtToIpAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :ip_addresses, :last_request_at, :datetime
  end
end
