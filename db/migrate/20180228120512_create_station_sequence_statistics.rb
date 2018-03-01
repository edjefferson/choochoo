class CreateStationSequenceStatistics < ActiveRecord::Migration[5.1]
  def change
    create_table :station_sequence_statistics do |t|
      t.integer :station_sequence_id
      t.string :sequence_type
      t.integer :max_length
      t.string :max_sequence_start

      t.timestamps
    end
  end
end
