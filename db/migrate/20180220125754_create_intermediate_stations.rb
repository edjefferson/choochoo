class CreateIntermediateStations < ActiveRecord::Migration[5.1]
  def change
    create_table :intermediate_stations do |t|
      t.integer :basic_schedule_id
      t.integer :tiploc_insert_id
      t.string :location
      t.time :scheduled_arrival_time
      t.time :scheduled_departure_time
      t.time :scheduled_pass
      t.time :public_arrival
      t.time :public_departure
      t.string :platform
      t.string :line
      t.string :path
      t.string :activity
      t.string :engineering_allowance
      t.string :pathing_allowance
      t.string :performance_allowance

      t.timestamps
    end
  end
end
