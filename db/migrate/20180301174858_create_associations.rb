class CreateAssociations < ActiveRecord::Migration[5.1]
  def change
    create_table :associations do |t|
      t.string :transaction_type
      t.string :base_uid
      t.string :assoc_uid
      t.date :assoc_start_date
      t.date :assoc_end_date
      t.string :assoc_days
      t.string :assoc_cat
      t.string :assoc_date_ind
      t.string :assoc_location
      t.string :base_location_suffix
      t.string :assoc_location_suffix
      t.string :diagram_type
      t.string :association_type
      t.string :filler
      t.string :stp_indicator

      t.timestamps
    end
  end
end
