class CreateStationSequences < ActiveRecord::Migration[5.1]
  def change
    create_table :station_sequences do |t|
      t.integer :tiploc_ids, array: true, default: []
      t.text :sequence, array: true, default: []
      t.integer :first_match_id

      t.timestamps
    end
  end
end
