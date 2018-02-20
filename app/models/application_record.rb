class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.import_from_csv
    db =  ActiveRecord::Base.connection.current_database
    if self.table_name == "basic_schedules" || self.table_name == "intermediate_stations"
      system "psql -d #{db} -c \"\\copy #{self.table_name} (#{(self.column_names).join(", ")}) from \'csv/#{self.table_name}.csv\' csv\""
    else
      system "psql -d #{db} -c \"\\copy #{self.table_name} (#{(self.column_names - ['id']).join(", ")}) from \'csv/#{self.table_name}.csv\' csv\""
    end
  end

  def self.truncate_table
    puts "truncating #{self.table_name} table"
    ActiveRecord::Base.connection_pool.with_connection do |conn|
      conn.execute("TRUNCATE #{self.table_name} RESTART IDENTITY")
    end
  end
end
