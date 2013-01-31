module Overnightable
  def self.included(model)
    model.class_eval do
      before_validation :prepare_overnightable, if: :has_overnight_timespan?
      after_save        :create_or_update_next_day!, if: :overnight_processing_needed?
      after_destroy     :destroy_next_day, if: :next_day
    end
  end

  def is_overnight?
    next_day || previous_day
  end

  # We always edit the first day of an overnightable. In order for this to work, we need
  # to set the end time of the first day to the end time of the next day.  Call this
  # method in an before_filter of the model's controller for the edit action for example.
  #
  # This needs to be overwritten in the overnightable.
  # Example:
  # def init_overnight_end_time
  #   self.end_hour   = next_day.end_hour
  #   self.end_minute = next_day.end_minute
  # end
  def init_overnight_end_time
    raise NotImplementedError
  end

  protected

  # If a the overnightable has a overnight timespan, we need to set the end time of the
  # first day to the end of the day and remember the the original end time entered for
  # the creation of the next day.
  #
  # This needs to be overwritten in the overnightable.
  # Example:
  # def prepare_overnightable
  #   @next_day_end_hour = end_hour
  #   @next_day_end_minute = end_minute
  #   self.end_hour = 24
  #   self.end_minute = 0
  # end
  def prepare_overnightable
    raise NotImplementedError
  end

  def overnight_processing_needed?
    !overnightable_processed? && (next_day || has_overnight_timespan?)
  end

  def overnightable_processed?
    @overnightable_processed
  end

  def update_demands
    add_demands
    destroy_demands
  end

  def add_demands
    added_demands.each do |demand|
      demands << demand
    end
  end

  def added_demands
    previous_day.demands.select { |demand| demands.exclude?(demand) }
  end

  def destroy_demands
    destroyed_demands.each do |demand|
      demand.destroy
    end
  end

  def destroyed_demands
    demands.select { |demand| previous_day.demands.exclude?(demand) }
  end

  def destroy_next_day
    next_day.destroy
  end

  def has_overnight_timespan?
    @has_overnight_timespan ||= end_hour && start_hour && end_hour < start_hour
  end

  # if an hour range spanning over midnight is given, we split the shift. the second part is created here
  def create_or_update_next_day!
    if next_day.present?
      update_or_destroy_next_day!
    elsif has_overnight_timespan?
      create_next_day!
    end
  end

  def update_or_destroy_next_day!
    if has_overnight_timespan?
      update_next_day!
    else
      destroy_next_day
    end
  end

  def update_next_day!
    next_day.tap do |next_day|
      next_day.end_hour   = @next_day_end_hour
      next_day.end_minute = @next_day_end_minute
      next_day.team       = team
      next_day.day        = day + 1
      next_day.save!
      next_day.update_demands
    end
  end

  def create_next_day!
    begin
      self.next_day = build_and_save_next_day
      @overnightable_processed = true # prevents that callbacks are executed again after save
      save!
    ensure
      @overnightable_processed = false
    end
  end

  def build_and_save_next_day
    @has_overnight_timespan = nil # clear to protect it from duping
    dup.tap do |next_day|
      next_day.day = day + 1
      next_day.start_hour = 0
      next_day.start_minute = 0
      next_day.end_hour = @next_day_end_hour
      next_day.end_minute = @next_day_end_minute
      next_day.save!
      demands.each do |d|
        next_day.demands << d
      end
    end
  end
end
