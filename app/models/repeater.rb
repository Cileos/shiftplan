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
      s.quickie = repeatable.quickie
      s.save!
      repetitions << s
    end
  end

  def repetitions
    @repetitions || []
  end
end
