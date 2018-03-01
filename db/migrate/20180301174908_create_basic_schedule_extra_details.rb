class CreateBasicScheduleExtraDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :basic_schedule_extra_details do |t|
      t.integer :basic_schedule_id
      t.string :traction_class
      t.string :uic_code
      t.string :atoc_code
      t.string :applicable_timetable_code
      t.string :retail_train_id
      t.string :source

      t.timestamps
    end
  end
end
