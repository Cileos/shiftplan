module Stackable
  def bump_remaining_stack
    self.remaining_stack ||= 0
    self.remaining_stack += 1
    stacked_parents.each(&:bump_remaining_stack)
  end

  def self.included(base)
    base.class_eval do
      attr_accessor :stack
      attr_accessor :remaining_stack
      attr_accessor :stacked_parents
    end
  end

  def total_stack
    stack + remaining_stack + 1 # except myself
  end

  # ignores real date, just checks hours
  def overlap?(other)
    other.stack == stack && cover?(other)
  end

  # OPTIMIZE also used in ConflictFinder
  def cover?(other)
    time_range.cover?(other.starts_at) || other.time_range.cover?(starts_at) || starts_at == other.starts_at
  end
end

