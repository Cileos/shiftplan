module Overnightable
  def self.included(model)
    model.class_eval do

      belongs_to :next_day, class_name: 'Shift'
      has_one    :previous_day, class_name: 'Shift', foreign_key: 'next_day_id'

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

  def overnight_processing_needed?
    !overnightable_processed? && (next_day || has_overnight_timespan?)
  end

  def overnightable_processed?
    @overnightable_processed
  end

  def destroy_next_day
    next_day.destroy
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

  def create_next_day!
    begin
      @has_overnight_timespan = nil # clear to protect it from duping in build_and_save_next_day
      self.next_day = build_and_save_next_day
      @overnightable_processed = true # prevents that callbacks are executed again after save
      save!
    ensure
      @overnightable_processed = false
    end
  end

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

  # Checks if the model has an overnight timespan. We also need to remember if an
  # overnight timespan was initally given because the end times get set to the end of
  # the day for the first day of the overnightable in the prepare_overnightable hook
  # later.
  #
  # This needs to be overwritten in the overnightable.
  # Example:
  # def has_overnight_timespan?
  #   @has_overnight_timespan ||= end_hour && start_hour && end_hour < start_hour
  # end
  def has_overnight_timespan?
    raise NotImplementedError
  end

  # As we always edit the first day of an overnightable, we need to update the next day of
  # an overnightable according to the changes made to the first day.
  # You should set the end time of the next day to the initially entered end time which
  # was remembered in instance variables in the prepare_overnightable hook.
  #
  # This needs to be overwritten in the overnightable to your own needs.
  # Example:
  # def update_next_day!
  #   next_day.tap do |next_day|
  #     next_day.end_hour   = @next_day_end_hour
  #     next_day.end_minute = @next_day_end_minute
  #     next_day.team       = team
  #     next_day.day        = day + 1
  #     next_day.save!
  #     next_day.update_demands
  #   end
  # end
  def update_next_day!
    raise NotImplementedError
  end

  # This methods builds the next day of an overnightable.
  # You should set the end time of the next day to the initially entered end time which
  # was remembered in instance variables in the prepare_overnightable hook.
  #
  # Please implement this according to the needs of your overnightable.
  # Example:
  # def build_and_save_next_day
  #   dup.tap do |next_day|
  #     next_day.day = day + 1
  #     next_day.start_hour = 0
  #     next_day.start_minute = 0
  #     next_day.end_hour = @next_day_end_hour
  #     next_day.end_minute = @next_day_end_minute
  #     next_day.save!
  #     demands.each do |d|
  #       next_day.demands << d
  #     end
  #   end
  # end
  def build_and_save_next_day
    raise NotImplementedError
  end
end
