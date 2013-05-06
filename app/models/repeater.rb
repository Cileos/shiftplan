class Repeater

  attr_reader :repeatable
  attr_accessor :repetitions

  def initialize(repeatable)
    @repeatable = repeatable
  end

  def non_repeatable_attributes
    ['starts_at', 'ends_at', 'created_at', 'updated_at', 'next_day_id']
  end

  def repeatable_attributes
    repeatable.attributes.except(*non_repeatable_attributes)
  end

  def repeat_for_days
    repeatable.repeat_for_days.reject do |day|
      day.blank? || repeatable.date.to_s == day
    end
  end

  def repeat!
    self.repetitions = repeat_for_days.inject([]) do |repetitions, day|
      s = ::Scheduling.new(repeatable_attributes)
      s.date = day
      s.team = repeatable.team
      s.start_hour = repeatable.start_hour
      # Repetitions must be initialized with the original end hour of the
      # repeatable so that they will become overnightables, too.
      s.end_hour = repeatable.is_overnight? ? repeatable.next_day.end_hour : repeatable.end_hour
      s.save!
      repetitions << s
    end
  end

  def repetitions
    @repetitions || []
  end
end
