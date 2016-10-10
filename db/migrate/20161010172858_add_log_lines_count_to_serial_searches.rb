class AddLogLinesCountToSerialSearches < ActiveRecord::Migration[5.0]
  def change
    add_column :serial_searches, :log_lines_count, :integer, default: 0
  end
end
