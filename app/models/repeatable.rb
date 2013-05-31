module Repeatable

  def self.included(model)
    model.class_eval do
      after_save :repeat!

      attr_writer :repetitions

      attr_accessor :days # TODO: :employees, :teams
    end
  end

  def repetitions
    @repetitions || []
  end

  def repeat!
    repeat_for_days! if days.present?
    # TODO
    # repeat_for_employees!
    # repeat_for_teams!
  end

  def repeat_for_days!
    # As a checkbox group is used for days, the blank value is always included
    # in the parameters and needs to be rejected.  The day for the scheduling
    # itself will also be included in the parameters as the weekday for it it
    # will always we checked along with the repetitions. It needs to be rejected
    # from the repetition creation, too.
    self.repetitions = days.reject {|day| day.blank? || date == day.to_date }.map do |day|
      repeat_for_day!(day)
    end
  end

  def repeat_for_day!(day)
    self.class.new(repeatable_attributes).tap do |repetition|
      repetition.date = day
      repetition.start_hour = start_hour
      # Repetitions must be initialized with the original end hour of the
      # repeatable so that they will become overnightables, too.
      repetition.end_hour = is_overnight? ? next_day.end_hour : end_hour
      repetition.save!
    end
  end

  def non_repeatable_attributes
    ['starts_at', 'ends_at', 'created_at', 'updated_at', 'next_day_id', 'id']
  end

  def repeatable_attributes
    attributes.except(*non_repeatable_attributes)
  end
end
