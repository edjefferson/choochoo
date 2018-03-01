class StationSequence < ApplicationRecord
  has_many :basic_schedule_sequences
  has_many :station_sequence_statistics

  def self.select_avaiable_sequences_on(date)
    find_by_sql("SELECT * FROM clients
  INNER JOIN orders ON clients.id = orders.client_id
  ORDER BY clients.created_at desc")
    select('DISTINCT ON (train_uid) train_uid, *').where("date_runs_from <= ? and date_runs_to >=  ? and substring(days_run from ? for 1) = '1'", date, date, date.wday).order("train_uid, stp_indicator, date_runs_from").group("id").having("stp_indicator != 'C'")
  end

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

  def self.update_sequence_stats
    self.order(:id).each(&:check_sequence)
  end

  def check_sequence
    check_for_sequence("is_alphabetical")
    check_for_sequence("is_qwertical")
    check_for_sequence("is_increasing")
    check_for_sequence("is_alliterative")
    check_for_sequence("is_alphabetical_initial")
    check_for_sequence("is_alphabetical_sequential")
  end

  def check_for_sequence(check)
    max = 1
    current = 1
    max_sequence_start = ""
    sequence_start = ""

    sequence = self.sequence
    #puts sequence
    sequence.each_with_index do |station, index|
      if index == 0
        sequence_start = station
      elsif index > 0
        previous_station = sequence[index - 1]
        if eval(check + "(previous_station, station)")
          current += 1
          if max < current
            max = current
            max_sequence_start = sequence_start
          end
        else
          sequence_start = station
          current = 1
        end
      end
    end
    station_sequence_statistic = StationSequenceStatistic.where(station_sequence_id: self.id, sequence_type: check.split("_")[1..-1].join).first_or_create
    station_sequence_statistic.update(max_length: max, max_sequence_start: max_sequence_start)
  end



  def is_alphabetical(prev, current)
    true if prev < current
  end

  def is_qwertical(prev, current)
    letter_hash = {}
    qwertybet = "QWERTYUIOPASDFGHJKLZXCVBNM"
                "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    alphabet = ('A'..'Z').to_a.join
    prev_qwerty = prev.upcase.tr qwertybet, alphabet
    current_qwerty = current.upcase.tr qwertybet, alphabet
  
    true if prev_qwerty < current_qwerty
  end

  def is_increasing(prev, current)
    true if prev.length < current.length
  end

  def is_alliterative(prev, current)
    true if prev[0] == current[0]
  end

  def is_alphabetical_initial(prev, current)
    true if prev[0] < current[0]
  end

  def is_alphabetical_sequential(prev, current)
    true if prev.ord == current.ord - 1
  end
end
