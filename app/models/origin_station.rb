class OriginStation < ApplicationRecord
  belongs_to :basic_schedule
  has_many :basic_schedule_sequences
  belongs_to :tiploc_insert
end
