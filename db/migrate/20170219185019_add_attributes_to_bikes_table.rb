class AddAttributesToBikesTable < ActiveRecord::Migration[5.0]
  def change
    add_column :bikes, :title, :string
    add_column :bikes, :serial, :text
  end
end
