class IntermediateStation < ApplicationRecord
  belongs_to :basic_schedule
  belongs_to :tiploc_insert

  def tps_description
    TiplocInsert.find(self.tiploc_insert_id).tps_description
  end

  def is_stop?
    if self.activity?
      activities = self.activity.scan(/.{2}/)
      activities.map! do |activity|
        activity.strip == "" ? nil : activity.strip
      end
      activities.compact!
      true if activities
    end
  end
end
