class AddPgTrgmExtensionToDb < ActiveRecord::Migration[5.0]
  def up
    execute 'CREATE EXTENSION pg_trgm;'
  end

  def down
    execute 'DROP EXTENSION pg_trgm'
  end
end
