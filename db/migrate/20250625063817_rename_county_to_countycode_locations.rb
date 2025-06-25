class RenameCountyToCountycodeLocations < ActiveRecord::Migration[8.0]
  def change
    rename_column :locations, :country, :country_code
  end
end
