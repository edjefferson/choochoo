class BasicScheduleSequence < ApplicationRecord
  belongs_to :origin_station
  belongs_to :terminating_station
  belongs_to :basic_schedule
  belongs_to :station_sequence

  def self.collect_sequences
    puts "collecting basic_schedule_sequences".blue
    ActiveRecord::Base.connection_pool.with_connection do |conn|
      conn.execute("TRUNCATE basic_schedule_sequences RESTART IDENTITY")

      puts "importing intermediate_stations".blue

      conn.execute("INSERT into basic_schedule_sequences (created_at, updated_at, basic_schedule_id,
      intermediate_station_ids, intermediate_station_tiploc_ids, intermediate_station_activities)
      SELECT now(), now(), bs.id, array_agg(ints.id order by ints.id),
      array_agg(ints.tiploc_insert_id ORDER by ints.id),
      array_agg(regexp_split_to_array(rpad(coalesce(ints.activity,''),12),E'(?=(..)+$)') ORDER by ints.id)
      FROM basic_schedules bs
      JOIN intermediate_stations ints ON ints.basic_schedule_id = bs.id group by bs.id")

      puts "importing origin_stations".blue

      conn.execute("UPDATE basic_schedule_sequences bss
        SET origin_station_id = o.id, origin_station_tiploc_id = o.tiploc_insert_id,
        origin_station_activity = regexp_split_to_array(o.activity,E'(?=(..)+$)')
        FROM origin_stations o WHERE o.basic_schedule_id = bss.basic_schedule_id")

        puts "importing terminating_stations".blue

        conn.execute("UPDATE basic_schedule_sequences bss
        SET terminating_station_id = o.id, terminating_station_tiploc_id = o.tiploc_insert_id,
        terminating_station_activity = regexp_split_to_array(o.activity,E'(?=(..)+$)')
        FROM terminating_stations o WHERE o.basic_schedule_id = bss.basic_schedule_id")
    end
    puts "sequence import complete".green
  end

  def get_station_sequence(tiploc_sequences)
    if self.origin_station_tiploc_id
      tiploc_sequence = [self.origin_station_tiploc_id]
      self.intermediate_station_tiploc_ids.each_with_index do |tiploc_id, index|
        if self.intermediate_station_activities[index] & ["U ","D ","T ","R "] != []
          if tiploc_sequence[-1] != tiploc_id
            tiploc_sequence << tiploc_id
          end
        end
      end
      tiploc_sequence << self.terminating_station_tiploc_id
      tiploc_sequence_string = "{" + tiploc_sequence.join(", ") + "}"
      tiploc_sequences << {id: self.id, tiploc_ids: tiploc_sequence_string, created_at:Time.now , updated_at: Time.now}
      print "#{self.id}\r"
    end
    return tiploc_sequences
  end

  def self.export_station_sequences_to_csv
    CSV.open("csv/station_sequences.csv", "w")
    tiploc_sequences = []
    self.update_all(station_sequence_id: nil)
    self.all.order(:id).find_each do |x|
      tiploc_sequences = x.get_station_sequence(tiploc_sequences)
    end
    CSV.open("csv/station_sequences.csv", "a") do |csv|
      tiploc_sequences.each {|tiploc_sequence| csv << tiploc_sequence.values}
    end
  end
end
