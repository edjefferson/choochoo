class TiplocInsert < ApplicationRecord
  reverse_geocoded_by :latitude, :longitude

  has_many :basic_schedules
  has_many :intermediate_stations
  has_many :origin_stations
  has_many :terminating_stations

  def self.copy_tiploc_ids_to_stations
    (1..7).to_a.each do |num|
      OriginStation.connection.update("UPDATE origin_stations AS s SET tiploc_insert_id = t.id FROM tiploc_inserts AS t WHERE left(location,#{num}) = t.tiploc")
      puts "imported #{num} letter origin tiplocs"
    end
    (1..7).to_a.each do |num|
      IntermediateStation.connection.update("UPDATE intermediate_stations AS s SET tiploc_insert_id = t.id FROM tiploc_inserts AS t WHERE left(location,#{num}) = t.tiploc")
      puts "imported #{num} letter intermediate tiplocs"
    end
    (1..7).to_a.each do |num|
      TerminatingStation.connection.update("UPDATE terminating_stations AS s SET tiploc_insert_id = t.id FROM tiploc_inserts AS t WHERE left(location,#{num}) = t.tiploc")
      puts "imported #{num} letter terminating tiplocs"
    end
  end
end
