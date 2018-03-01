class BasicSchedule < ApplicationRecord
  has_one :origin_station
  has_one :terminating_station
  has_many :intermediate_stations
  has_one :basic_schedule_sequence
  has_one :station_sequence, through: :basic_schedule_sequence

  def self.select_active_schedules_on(date)
    select('DISTINCT ON (train_uid) train_uid, *').where("date_runs_from <= ? and date_runs_to >=  ? and substring(days_run from ? for 1) = '1'", date, date, date.wday).order("train_uid, stp_indicator, date_runs_from")#.group("id").having("stp_indicator != 'C'")
  end

  def self.import_all_schedule_data_from_csv
    [TiplocInsert,BasicSchedule,OriginStation,IntermediateStation,TerminatingStation].each do |model|
      model.truncate_table
      model.import_from_csv
    end
  end
end
