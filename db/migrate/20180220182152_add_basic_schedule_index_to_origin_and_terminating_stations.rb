class AddBasicScheduleIndexToOriginAndTerminatingStations < ActiveRecord::Migration[5.1]
  def change
    add_index :origin_stations, :basic_schedule_id
    add_index :terminating_stations, :basic_schedule_id
  end
end
