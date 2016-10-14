class RenameBikeIndexBikesTableToBikes < ActiveRecord::Migration[5.0]
  def change
    rename_table(:bike_index_bikes, :bikes)
  end
end
