class IntermediateStation < ApplicationRecord
  belongs_to :basic_schedule
  belongs_to :tiploc_insert
end
