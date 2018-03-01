class BasicSchedulesController < ApplicationController
  def index
    @basic_schedules_count = BasicSchedule.where("date_runs_from <= ? and date_runs_to >=  ? and substring(days_run from ? for 1) = '1'", Date.today, Date.today, Date.today.wday).count


    @active_schedules_count = BasicSchedule.select_active_schedules_on(Date.today).length
    @un_cancelled_schedules = BasicSchedule.select_active_schedules_on(Date.today).to_a.select {|x| x.stp_indicator != 'C'}
    @un_cancelled_schedule_ids = @un_cancelled_schedules.map {|x| x.id}
    @sequences = StationSequence.joins(:basic_schedule_sequences).where("basic_schedule_sequences.id in (?)", @un_cancelled_schedule_ids).select("station_sequences.id,sequence").order(:id).distinct
    #@un_cancelled_schedules = BasicSchedule.find(id: @un_cancelled_schedule_ids)
  end

  def show
    @basic_schedule = BasicSchedule.includes(:origin_station, :intermediate_stations, :terminating_station, :basic_schedule_sequence).find(params[:id])
    @basic_schedule_sequence = @basic_schedule.basic_schedule_sequence
    @origin_station = TiplocInsert.find(@basic_schedule_sequence.origin_station_tiploc_id).tps_description
    @terminating_station = TiplocInsert.find(@basic_schedule_sequence.terminating_station_tiploc_id).tps_description
  end
end
