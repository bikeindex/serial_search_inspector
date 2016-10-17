class AddWasStolenToBikes < ActiveRecord::Migration[5.0]
  def change
    add_column :bikes, :was_stolen, :boolean
  end
end
