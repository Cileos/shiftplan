class ConflictFinder < Struct.new(:schedulings)

  def call
    schedulings.each do |me|
      me.conflicts = they.select do |it|
        overlapping?(it, me)
      end
    end
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
