class AddTiplocIndexToIntermediateStations < ActiveRecord::Migration[5.1]
  def change
    add_index :intermediate_stations, :tiploc_insert_id
  end
end
