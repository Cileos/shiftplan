module Repeatable

  def self.included(model)
    model.class_eval do
      after_save :create_repetitions

      attr_accessor :repeat_for_days, :repeater
    end
  end

  def create_repetitions
    if repeat_for_days?
      @repeater = Repeater.new(self)
      @repeater.repeat!
    end
  end

  def repeat_for_days?
    repeat_for_days.present?
  end

  def repetitions
    if @repeater
      @repeater.repetitions
    else
      []
    end
  end
end
