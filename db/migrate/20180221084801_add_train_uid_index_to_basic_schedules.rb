class AddTrainUidIndexToBasicSchedules < ActiveRecord::Migration[5.1]
  def change
    add_index :basic_schedules, :train_uid
  end
end
