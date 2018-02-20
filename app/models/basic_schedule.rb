class BasicSchedule < ApplicationRecord
  has_one :origin_station
  has_one :terminating_station
  has_many :intermediate_stations
  has_one :basic_schedule_sequence
  has_one :station_sequence, through: :basic_schedule_sequence
end
