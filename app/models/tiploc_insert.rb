class TiplocInsert < ApplicationRecord
  reverse_geocoded_by :latitude, :longitude

  has_many :basic_schedules
  has_many :intermediate_stations
  has_many :origin_stations
  has_many :terminating_stations

  def self.import_lat_longs
    csv_data = CSV.read('tiploc_easting_and_northings.csv', {headers: true})
    easting_and_northings_hash = {}
    csv_data.each { |line| easting_and_northings_hash[line[0]] = [line[2].to_i,line[3].to_i]}
    self.order(:id).each do |tiploc_insert|
      easting_and_northing = easting_and_northings_hash[tiploc_insert.tiploc]
      if easting_and_northing
        easting, northing = easting_and_northing
        lat_long = get_lat_long(easting, northing)
        puts "fault #{lat_long.lat}, #{lat_long.long}"
        tiploc_insert.update(latitude: lat_long.lat, longitude: lat_long.long)
      end
    end
  end

  def self.get_lat_long(easting, northing)
    Silva::Location.from(:en, :easting => easting, :northing => northing).to(:wgs84)
  end


  def distance_to(end_point)
    Geocoder::Calculations.distance_between(self, end_point)
  end

  
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
