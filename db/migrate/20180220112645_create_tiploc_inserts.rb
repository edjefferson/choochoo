class CreateTiplocInserts < ActiveRecord::Migration[5.1]
  def change
    create_table :tiploc_inserts do |t|
      t.string :tiploc
      t.string :capitals
      t.string :nalco
      t.string :nlc_check
      t.string :tps_description
      t.string :stanox
      t.string :po_mcp_code
      t.string :crs_code
      t.string :description
      t.string :new_tiploc
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
