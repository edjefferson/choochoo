class AddBasicScheduleIndexToBasicScheduleSequences < ActiveRecord::Migration[5.1]
  def change
    add_index :basic_schedule_sequences, :basic_schedule_id
  end
end
