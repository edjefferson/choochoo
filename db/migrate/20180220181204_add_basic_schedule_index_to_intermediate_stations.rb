class AddBasicScheduleIndexToIntermediateStations < ActiveRecord::Migration[5.1]
  def change
    add_index :intermediate_stations, :basic_schedule_id
  end
end
