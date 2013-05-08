module Repeatable

  def self.included(model)
    model.class_eval do
      after_save :create_repetitions

      attr_accessor :repetitions

      attr_accessor :repeat_for_days # TODO: :repeat_for_employees, :repeat_for_teams
    end
  end

  def create_repetitions
    repeat!
  end

  def repeat!
    self.repetitions = []
    repeat_for_days! if repeat_for_days.present?
    # TODO
    # repeat_for_employees!
    # repeat_for_teams!
  end

  def repeat_for_days!
    repeat_for_days.each do |day|
      unless day.blank? || date.to_s == day
        repetition = self.class.new(repeatable_attributes)
        repetition.date = day
        repetition.start_hour = start_hour
        # Repetitions must be initialized with the original end hour of the
        # repeatable so that they will become overnightables, too.
        repetition.end_hour = is_overnight? ? next_day.end_hour : end_hour
        repetition.save!
        self.repetitions << repetition
      end
    end
  end

  def non_repeatable_attributes
    ['starts_at', 'ends_at', 'created_at', 'updated_at', 'next_day_id']
  end

  def repeatable_attributes
    attributes.except(*non_repeatable_attributes)
  end
end
