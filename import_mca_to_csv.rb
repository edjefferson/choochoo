require 'active_record'
require './app/lib/import.rb'
require 'csv'

ActiveRecord::Base.establish_connection(
  :adapter  => "postgresql",
  :host     => "localhost",
  :database => "ChooChoo_development"
)

class TiplocInsert < ActiveRecord::Base
end

class BasicSchedule < ActiveRecord::Base
end

class BasicScheduleExtraDetail < ActiveRecord::Base
end

class OriginStation < ActiveRecord::Base
end

class IntermediateStation < ActiveRecord::Base
end

class TerminatingStation < ActiveRecord::Base
end

class Association < ActiveRecord::Base
end

class ChangeEnRoute < ActiveRecord::Base
end

def run_import_sequence(filename)
  import = Import.new(filename, "ChooChoo_development")
  import.start_import
end

 run_import_sequence("ttis828/ttisf828.mca")
