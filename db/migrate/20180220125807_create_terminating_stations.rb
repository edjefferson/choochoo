class CreateTerminatingStations < ActiveRecord::Migration[5.1]
  def change
    create_table :terminating_stations do |t|
      t.integer :basic_schedule_id
      t.integer :tiploc_insert_id
      t.string :location
      t.time :scheduled_arrival_time
      t.time :public_arrival_time
      t.string :platform
      t.string :path
      t.string :activity

      t.timestamps
    end
  end
end
