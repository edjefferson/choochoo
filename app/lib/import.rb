class Import
  attr_accessor :filename, :basic_schedule_id, :intermediate_station_id, :data_for_import, :database

  def initialize(filename, database)
    @database = database
    @filename = filename
    @basic_schedule_id = 0
    @intermediate_station_id = 0
    empty_data_for_import
  end


  def start_import
    puts "importing #{self.filename}"

    puts "emptying CSVs"
    empty_csvs

    process_file(self.filename)
    export_to_csv(-1)
    puts "truncating tables"
    truncate_tables
    import_from_csv_to_db
    puts "IMPORT COMPLETE"
  end

  def tables
    [TiplocInsert,Association,BasicSchedule,BasicScheduleExtraDetail,OriginStation,IntermediateStation,TerminatingStation,ChangeEnRoute]
  end

  def truncate_tables
    table_string = tables.map { |table| table.table_name}.join(", ")
    ActiveRecord::Base.connection_pool.with_connection do |conn|
      conn.execute("TRUNCATE #{table_string} RESTART IDENTITY")
      #conn.execute("VACUUM")
    end
  end

  def process_file(file)
    file_size = File.readlines(file).count
    File.foreach(file).with_index do |line, index|
      if (index + 1) % 100000 == 0
        export_to_csv(index)
      end
      print "#{index +1}/#{file_size}\r"
      process_line(line)
    end
  end

  def process_line(line)
    line_array = line.split(//)
    record_identity = line_array.shift(2).join

    if record_identity == "HD"
      line_array.join
    elsif record_identity == "TI"
      self.data_for_import[:tiploc_inserts] << tiploc_insert(line_array)
    elsif record_identity == "AA"
      self.data_for_import[:associations] << association(line_array)
    elsif record_identity == "BS"
      self.data_for_import[:basic_schedules] << basic_schedule(line_array)
    elsif record_identity == "BX"
      self.data_for_import[:basic_schedule_extra_details] << basic_schedule_extra_detail(line_array)
    elsif record_identity == "LO"
      self.data_for_import[:origin_stations] << origin_station(line_array)
    elsif record_identity == "LI"
      self.data_for_import[:intermediate_stations] << intermediate_station(line_array)
    elsif record_identity == "CR"
      self.data_for_import[:change_en_routes] << change_en_route(line_array)
    elsif record_identity == "LT"
      self.data_for_import[:terminating_stations] << terminating_station(line_array)
    end
  end

  def nil_strip_add_dates(hash)
    hash.transform_values! do |value|
      if value.class != "a".class
        value
      elsif value.strip == ""
        nil
      else
        value.strip
      end
    end
    time = Time.now
    hash[:created_at] = time
    hash[:updated_at] = time
    return hash
  end

  def parse_time(time)
    if time.strip !=""
      hour = time[0..1]
      minute = time[2..3]
      parsed_time = Time.parse("#{hour}:#{minute}")
      second = time[5]
      if second == "H"
        parsed_time += 30
      end
      return parsed_time.strftime("%H:%M:%S")
    else
      return nil
    end
  end

  def tiploc_insert(line_array)
    nil_strip_add_dates({
      tiploc: line_array.shift(7).join.strip,
      capitals: line_array.shift(2).join.strip,
      nalco: line_array.shift(6).join.strip,
      nlc_check: line_array.shift(1).join.strip,
      tps_description: line_array.shift(26).join.strip.titleize,
      stanox: line_array.shift(5).join.strip,
      po_mcp_code: line_array.shift(4).join.strip,
      crs_code: line_array.shift(3).join.strip,
      description: line_array.shift(16).join.strip,
      new_tiploc: line_array.shift(7).join.strip,
      latitude: nil,
      longitude: nil
    })
  end

  def association(line_array)
    nil_strip_add_dates({
      transaction_type: line_array.shift(1).join,
      base_uid: line_array.shift(6).join,
      assoc_uid: line_array.shift(6).join,
      assoc_start_date: line_array.shift(6).join,
      assoc_end_date: line_array.shift(6).join,
      assoc_days: line_array.shift(7).join,
      assoc_cat: line_array.shift(2).join,
      assoc_date_ind: line_array.shift(1).join,
      assoc_location: line_array.shift(7).join,
      base_location_suffix: line_array.shift(1).join,
      assoc_location_suffix: line_array.shift(1).join,
      diagram_type: line_array.shift(1).join,
      association_type: line_array.shift(1).join,
      filler: line_array.shift(1).join,
      stp_indicator: line_array.shift(1).join
    })
  end

  def basic_schedule(line_array)
    nil_strip_add_dates({
      id: self.basic_schedule_id += 1,
      transaction_type: line_array.shift(1).join,
      train_uid: line_array.shift(6).join,
      date_runs_from: line_array.shift(6).join,
      date_runs_to: line_array.shift(6).join,
      days_run: line_array.shift(7).join,
      bank_holiday_running: line_array.shift(1).join,
      train_status: line_array.shift(1).join,
      train_category: line_array.shift(2).join,
      train_identity: line_array.shift(4).join,
      headcode: line_array.shift(4).join,
      course_indicator: line_array.shift(1).join,
      profit_centre_code: line_array.shift(8).join,
      business_sector: line_array.shift(1).join,
      power_type: line_array.shift(3).join,
      timing_load: line_array.shift(4).join,
      speed: line_array.shift(3).join,
      operating_chars: line_array.shift(6).join,
      train_class: line_array.shift(1).join,
      sleepers: line_array.shift(1).join,
      reservations: line_array.shift(1).join,
      connect_indicator: line_array.shift(1).join,
      catering_code: line_array.shift(4).join,
      service_branding: line_array.shift(4).join,
      spare: line_array.shift(1).join,
      stp_indicator: line_array.shift(1).join
    })
  end

  def basic_schedule_extra_detail(line_array)
    nil_strip_add_dates({
      basic_schedule_id: self.basic_schedule_id,
      traction_class: line_array.shift(4).join,
      uic_code: line_array.shift(5).join,
      atoc_code: line_array.shift(2).join,
      applicable_timetable_code: line_array.shift(1).join,
      retail_train_id: line_array.shift(8).join,
      source: line_array.shift(8).join
    })
  end

  def origin_station(line_array)
    nil_strip_add_dates({
      basic_schedule_id: self.basic_schedule_id,
      tiploc_insert_id: nil,
      location: line_array.shift(8).join,
      scheduled_departure_time: parse_time(line_array.shift(5).join),
      public_departure_time: parse_time(line_array.shift(4).join),
      platform: line_array.shift(3).join,
      line: line_array.shift(3).join,
      engineering_allowance: line_array.shift(2).join,
      pathing_allowance: line_array.shift(2).join,
      activity: line_array.shift(12).join,
      performance_allowance: line_array.shift(2).join
    })
  end

  def intermediate_station(line_array)
    nil_strip_add_dates({
      id: self.intermediate_station_id += 1,
      basic_schedule_id: self.basic_schedule_id,
      tiploc_insert_id: nil,
      location: line_array.shift(8).join,
      scheduled_arrival_time: parse_time(line_array.shift(5).join),
      scheduled_departure_time: parse_time(line_array.shift(5).join),
      scheduled_pass: parse_time(line_array.shift(5).join),
      public_arrival: parse_time(line_array.shift(4).join),
      public_departure: parse_time(line_array.shift(4).join),
      platform: line_array.shift(3).join,
      line: line_array.shift(3).join,
      path: line_array.shift(3).join,
      activity: line_array.shift(12).join,
      engineering_allowance: line_array.shift(2).join,
      pathing_allowance: line_array.shift(2).join,
      performance_allowance: line_array.shift(2).join
    })
  end

  def terminating_station(line_array)
    nil_strip_add_dates({
      basic_schedule_id: self.basic_schedule_id,
      tiploc_insert_id: nil,
      location: line_array.shift(8).join,
      scheduled_arrival_time: parse_time(line_array.shift(5).join),
      public_arrival_time: parse_time(line_array.shift(4).join),
      platform: line_array.shift(3).join,
      path: line_array.shift(3).join,
      activity: line_array.shift(12).join
    })
  end

  def change_en_route(line_array)
    nil_strip_add_dates({
      intermediate_station_id: self.intermediate_station_id,
      location: line_array.shift(8).join,
      train_category: line_array.shift(2).join,
      train_identity: line_array.shift(4).join,
      headcode: line_array.shift(4).join,
      course_indicator: line_array.shift(1).join,
      profit_centre_code: line_array.shift(8).join,
      business_sector: line_array.shift(1).join,
      power_type: line_array.shift(3).join,
      timing_load: line_array.shift(4).join,
      speed: line_array.shift(3).join,
      operating_chars: line_array.shift(6).join,
      train_class: line_array.shift(1).join,
      sleepers: line_array.shift(1).join,
      reservations: line_array.shift(1).join,
      connect_indicator: line_array.shift(1).join,
      catering_code: line_array.shift(4).join,
      service_branding: line_array.shift(4).join,
      traction_class: line_array.shift(4).join,
      uic_code: line_array.shift(4).join,
      retail_train_id: line_array.shift(8).join
    })
  end

  def empty_csvs
    [
      "tiploc_inserts",
      "associations",
      "basic_schedules",
      "basic_schedule_extra_details",
      "origin_stations",
      "intermediate_stations",
      "terminating_stations",
      "change_en_routes"
    ].each do |file|
      CSV.open("csv/#{file}.csv", "w")
    end
  end

  def empty_data_for_import
    self.data_for_import = {
      tiploc_inserts: [],
      associations: [],
      basic_schedules: [],
      basic_schedule_extra_details: [],
      origin_stations: [],
      intermediate_stations: [],
      terminating_stations: [],
      change_en_routes: []
    }
  end

  def export_to_csv(index)
    if index == -1
      puts "exporting final set of lines"
    else
      puts "exporting upto line #{index + 1}"
    end
    self.data_for_import.each do |key, value|
      CSV.open("csv/#{key}.csv", "a") do |csv|
        value.each {|line| csv << line.values}
      end
    end
    empty_data_for_import
  end

  def import_from_csv_to_db
    puts "importing CSVs to database"
    tables.each do |table|
      if table.table_name == "basic_schedules" || table.table_name == "intermediate_stations"
        system "psql -d #{self.database} -c \"\\copy #{table.table_name} (#{(table.column_names).join(", ")}) from \'csv/#{table.table_name}.csv\' csv\""
      else
        system "psql -d #{self.database} -c \"\\copy #{table.table_name} (#{(table.column_names - ['id']).join(", ")}) from \'csv/#{table.table_name}.csv\' csv\""
      end
    end
  end
end
