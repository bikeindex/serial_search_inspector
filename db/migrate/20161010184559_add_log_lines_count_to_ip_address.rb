class AddLogLinesCountToIpAddress < ActiveRecord::Migration[5.0]
  def change
    add_column :ip_addresses, :log_lines_count, :integer, default: 0
  end
end
