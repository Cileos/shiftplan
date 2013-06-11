# The importing model will support overnight timespans. When crossing the day boundary, it
# will be split into 2 parts.
#
# The foreign key 'next_day_id' has to be added to the database table of the importing
# model so that the next_day and previous_day associations will work.
#
# Prerequisites:
#   starts_at and ends_at are set, will only be touched if ends_at < starts_at
#
# Results:
#   ends_at fixed
#   second record spanning the time of the next day

module Overnightable
  def self.included(model)
    model.class_eval do

      belongs_to :next_day, class_name: name
      has_one    :previous_day, class_name: name, foreign_key: 'next_day_id'

      before_validation :update_or_destroy_next_day_for_overnightable,  if: :next_day
      before_validation :build_next_day_for_overnightable,              unless: :next_day
      after_save        :save_next_day_for_overnightable
      after_destroy     :destroy_next_day_for_overnightable,            if: :next_day

    end
  end

  def is_overnight?
    next_day || previous_day
  end

  def pairing_id
    if previous_day.present?
      previous_day.id
    elsif next_day.present?
      id
    end
  end

  # We always edit the first day of an overnightable. This makes it necessary to
  # initialize the first day with the end_hour and end_minute of the next day.
  # You might need to call this in your controller in an before_filter for the edit action
  # to make sure the first day of your overnightable gets correctly initialized.
  def merge_time_components_from_next_day!
    self.end_hour   = next_day.ends_at.hour
    self.end_minute = next_day.ends_at.min
  end

  protected

  # Builds the next day if an overnight timespan is present. Takes care of splitting the
  # overnightable at midnight. (The next_day will start at 00:00 on the next day, the
  # first day/previous day will end at 23:59)
  def build_next_day_for_overnightable
    if has_overnight_timespan?
      self.next_day = dup.tap do |tomorrow|
        if tomorrow.respond_to?(:quickie=)
          tomorrow.quickie = nil
        end
        tomorrow.day = day + 1 if tomorrow.respond_to?(:day)
        tomorrow.starts_at = ends_at.tomorrow.beginning_of_day
        tomorrow.ends_at = ends_at + 1.day
        tomorrow.next_day = nil # prevents that a next day for the next day will be created
        tomorrow.days = [] if tomorrow.respond_to?(:days) # prevents that the next day is repeated, only first day should be repeated
      end
      self.ends_at = ends_at.end_of_day # split at midnight, end_of_day returns 23:59
    end
  end

  # As we always edit the first day of an overnightable, we need to update the next day of
  # an overnightable according to the changes made.
  # Takes care of splitting the overnightable at midnight. (The next_day will start at
  # 00:00 on the next day, the first day/previous day will end at 23:59)
  def update_next_day
    next_day.tap do |tomorrow|
      if tomorrow.respond_to?(:day)
        tomorrow.day = day + 1 # for shifts
      else
        tomorrow.starts_at = (starts_at + 1.day).beginning_of_day # for schedulings
      end
      tomorrow.ends_at = ends_at + 1.day
      tomorrow.employee = employee if tomorrow.respond_to?(:employee)
      tomorrow.team = team
      tomorrow.next_day = nil # prevents that a next day for the next day will be created
    end
    self.ends_at = ends_at.end_of_day # split at midnight, end_of_day returns 23:5
  end

  # After the first day of the overnightable has been saved, this method takes care of
  # saving the next day which has been build or updated before validation of the first
  # day.
  def save_next_day_for_overnightable
    if next_day.present?
      next_day.save!
      next_day.previous_day(true)
    end
  end

  # The next day has to be destroyed if either the overnightable has no overnight timespan
  # anymore after it has been updated or the overnightable's first day has been destroyed.
  def destroy_next_day_for_overnightable
    next_day.destroy
  end

  # If the overnightable still has an overnight timespan after it has been updated, the
  # next day is updated accordingly.
  # If the overnightable's new timespan does not span over midnight anymore, the next day
  # needs to be destroyed, though.
  def update_or_destroy_next_day_for_overnightable
    if has_overnight_timespan? # still overnight?
      update_next_day
    else
      destroy_next_day_for_overnightable
    end
  end

  # Checks if the model has an overnight timespan.
  def has_overnight_timespan?
    ends_at.present? && starts_at.present? && ends_at < starts_at
  end
end
