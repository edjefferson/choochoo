class CreateBasicScheduleSequences < ActiveRecord::Migration[5.1]
  def change
    create_table :basic_schedule_sequences do |t|
      t.integer :basic_schedule_id
      t.integer :origin_station_id
      t.integer :origin_station_tiploc_id
      t.text :origin_station_activity, array: true, default: []
      t.integer :intermediate_station_ids, array: true, default: []
      t.integer :intermediate_station_tiploc_ids, array: true, default: []
      t.text :intermediate_station_activities, array: true, default: []
      t.integer :terminating_station_id
      t.integer :terminating_station_tiploc_id
      t.text :terminating_station_activity, array: true, default: []
      t.integer :station_sequence_id

      t.timestamps
    end
  end
end
