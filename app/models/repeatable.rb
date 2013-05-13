module Repeatable

  def self.included(model)
    model.class_eval do
      after_save :create_repetitions

      attr_writer :repetitions

      attr_accessor :repeat_for_days # TODO: :repeat_for_employees, :repeat_for_teams
    end
  end

  def repetitions
    @repetitions || []
  end

  def create_repetitions
    repeat!
  end

  def repeat!
    repeat_for_days! if repeat_for_days.present?
    # TODO
    # repeat_for_employees!
    # repeat_for_teams!
  end

  def repeat_for_days!
    self.repetitions = repeat_for_days.reject {|day| day.blank? || date == day.to_date }.map do |day|
      repetition = self.class.new(repeatable_attributes)
      repetition.date = day
      repetition.start_hour = start_hour
      # Repetitions must be initialized with the original end hour of the
      # repeatable so that they will become overnightables, too.
      repetition.end_hour = is_overnight? ? next_day.end_hour : end_hour
      repetition.save!
      repetition
    end
  end

  def non_repeatable_attributes
    ['starts_at', 'ends_at', 'created_at', 'updated_at', 'next_day_id', 'id']
  end

  def repeatable_attributes
    attributes.except(*non_repeatable_attributes)
  end
end
