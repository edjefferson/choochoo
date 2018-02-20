class CreateBasicSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :basic_schedules do |t|
      t.string :transaction_type
      t.string :train_uid
      t.date :date_runs_from
      t.date :date_runs_to
      t.string :days_run
      t.string :bank_holiday_running
      t.string :train_status
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
      t.string :spare
      t.string :stp_indicator

      t.timestamps
    end
  end
end
