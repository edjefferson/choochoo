class AddJourneyLengthToBasicScheduleSequence < ActiveRecord::Migration[5.1]
  def change
    add_column :basic_schedule_sequences, :journey_length, :integer
  end
end
