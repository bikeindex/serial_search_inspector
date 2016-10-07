class AddLocationToIpAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :ip_addresses, :location, :string
  end
end
