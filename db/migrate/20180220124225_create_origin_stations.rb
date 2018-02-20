class CreateOriginStations < ActiveRecord::Migration[5.1]
  def change
    create_table :origin_stations do |t|
      t.integer :basic_schedule_id
      t.integer :tiploc_insert_id
      t.string :location
      t.time :scheduled_departure_time
      t.time :public_departure_time
      t.string :platform
      t.string :line
      t.string :engineering_allowance
      t.string :pathing_allowance
      t.string :activity
      t.string :performance_allowance

      t.timestamps
    end
  end
end
