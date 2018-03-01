class CreateChangeEnRoutes < ActiveRecord::Migration[5.1]
  def change
    create_table :change_en_routes do |t|
      t.integer :intermediate_station_id
      t.string :location
      t.string :train_category
      t.string :train_identity
      t.string :headcode
      t.string :course_indicator
      t.string :profit_centre_code
      t.string :business_sector
      t.string :power_type
      t.string :timing_load
      t.integer :speed
      t.string :operating_chars
      t.string :train_class
      t.string :sleepers
      t.string :reservations
      t.string :connect_indicator
      t.string :catering_code
      t.string :service_branding
      t.string :traction_class
      t.string :uic_code
      t.string :retail_train_id

      t.timestamps
    end
  end
end
