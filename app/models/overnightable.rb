# The importing model will support overnight timespans. When crossing the day boundary, it
# will be split into 2 parts.
#
# The foreign key 'next_day_id' has to be added to the database table of the importing
# model so that the next_day and previous_day associations will work.

module Overnightable
  def self.included(model)
    model.class_eval do

      belongs_to :next_day, class_name: model
      has_one    :previous_day, class_name: model, foreign_key: 'next_day_id'

      before_validation :update_or_destroy_next_day_for_night_shift
      before_validation :build_next_day_for_nightshift
      after_save        :save_next_day_for_nightshift
      after_destroy     :destroy_next_day_for_nightshift, if: :next_day

    end
  end

  def is_overnight?
    next_day || previous_day
  end

  def merge_time_components_from_next_day!
    self.end_hour   = next_day.ends_at.hour
    self.end_minute = next_day.ends_at.min
  end

  protected

  def build_next_day_for_nightshift
    if !next_day.present?
      if ends_at < starts_at
        self.next_day = dup.tap do |tomorrow|
          tomorrow.day = day + 1
          tomorrow.starts_at = ends_at.tomorrow.beginning_of_day
          tomorrow.ends_at = ends_at + 1.day
          tomorrow.next_day = nil # prevents that a next day for the next day will be created
        end
        self.ends_at = ends_at.end_of_day
      end
    end
  end

  # As we always edit the first day of an overnightable, we need to update the next day of
  # an overnightable according to the changes made to the first day.
  # You should set the end time of the next day to the initially entered end time which
  # was remembered in instance variables in the prepare_overnightable hook.
  #
  # This needs to be overwritten in the overnightable to your own needs.
  def update_next_day
    next_day.tap do |tomorrow|
      tomorrow.day = day + 1
      tomorrow.ends_at = ends_at + 1.day
      tomorrow.team = team
      tomorrow.next_day = nil # prevents that a next day for the next day will be created
    end
    self.ends_at = ends_at.end_of_day
  end

  def save_next_day_for_nightshift
    if next_day.present?
      next_day.save!
    end
  end

  def overnight_processing_needed?
    !overnightable_processed? && (next_day || has_overnight_timespan?)
  end

  def overnightable_processed?
    @overnightable_processed
  end

  def destroy_next_day_for_nightshift
    next_day.destroy
  end

  # If the overnightable still has an overnight timespan after it has been editited, the
  # next day is updated accordingly.
  # If the overnightable's new time range does not span
  # over midnight anymore, the next day needs to be destroyed, though.
  def update_or_destroy_next_day_for_night_shift
    if next_day.present?
      if ends_at < starts_at # still overnight?
        update_next_day
      else
        destroy_next_day_for_nightshift
      end
    end
  end


  # If an hour range spanning over midnight is given, we split the overnightable at the
  # end of the first day. The next day is created here.
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

  # Checks if the model has an overnight timespan. We also need to remember if an
  # overnight timespan was initally given because the end times get set to the end of
  # the day for the first day of the overnightable in the prepare_overnightable hook
  # later.
  def has_overnight_timespan?
    starts_at > ends_at
  end

  # DateTime#end_of_day returns 23:59:59, which we show as 24 o'clock
  def end_hour_respecting_end_of_day
    if ends_at.min >= 59 and ends_at.hour == 23
      24
    else
      ends_at.hour
    end
  end

  # DateTime#end_of_day returns 23:59:59, which we show as 24 o'clock
  def end_minute_respecting_end_of_day
    if ends_at.min >= 59 and ends_at.hour == 23
      0
    else
      ends_at.min
    end
  end
end
