class StationSequence < ApplicationRecord
  has_many :basic_schedule_sequences
  def self.import_sequences_from_csv
    self.truncate_table
    db = ActiveRecord::Base.connection.current_database
    system "psql -d #{db} -c \"\\copy station_sequences (id, tiploc_ids, created_at, updated_at) from csv/station_sequences.csv csv\""
    puts "tiplocs copied to database".blue

    ActiveRecord::Base.connection_pool.with_connection do |conn|
      conn.execute("UPDATE station_sequences SET sequence = temp_seq.descr FROM
        (SELECT t.id, array_agg(ti.tps_description ORDER by nr) as descr
        FROM station_sequences t, unnest(t.tiploc_ids) WITH ORDINALITY a(elem, nr),
        tiploc_inserts ti WHERE elem = ti.id GROUP by t.id) AS temp_seq
        WHERE station_sequences.id = temp_seq.id")
      puts "station names copied to database".blue

      conn.execute("UPDATE station_sequences SET first_match_id = temp_seq.m_id FROM
        (SELECT min(id) as m_id, sequence FROM station_sequences GROUP by sequence) as temp_seq where station_sequences.sequence = temp_seq.sequence")
      puts "found first version of each sequence".blue


      conn.execute("UPDATE basic_schedule_sequences SET station_sequence_id = station_sequences.first_match_id
        FROM station_sequences where basic_schedule_sequences.id = station_sequences.id")
      puts "copied sequence ids to basic_schedule_sequences".blue

      conn.execute("DELETE from station_sequences where id != first_match_id;")
      puts "deleted unused sequences".blue
    end

    puts "station sequence import complete".green
  end
end
