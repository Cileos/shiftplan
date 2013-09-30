class ConflictFinder < Struct.new(:schedulings)

  attr_reader :conflicts

  def initialize(*)
    super
    @conflicts = []
  end

  def call
    conflicts.clear
    schedulings.each do |me|
      found = they.select do |it|
        overlapping?(it, me)
      end
      me.conflicts = found
      unless found.empty?
        conflicts << Conflict.new(me, found)
      end
    end
  end


  def self.find_conflict_for(scheduling)
    self.new([scheduling]).tap(&:call).conflicts.first
  end

  private

  def they
    return [] if schedulings.empty?

    schedulings.first.class.between(
                                    schedulings.map(&:starts_at).min - 1.day,
                                    schedulings.map(&:ends_at).max + 1.day
    )
  end

  def overlapping?(x,y)
    x != y && x.employee_id == y.employee_id && x.cover?(y)
  end

end
