# Answers: "What are conflicts in the list of schedulings at the same time?"
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
        overlapping?(me, it)
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
    return @they if @they

    klass = schedulings.first.class
    s = klass.arel_table
    @they = klass.
      between(
        schedulings.map(&:starts_at).min - 1.day,
        schedulings.map(&:ends_at).max + 1.day
      ).
      where(
        s[:employee_id].in(scheduling_employee_ids).or(
          s[:represents_unavailability].eq(true).and(
            s[:employee_id].in(our_other_employee_ids)
          )
        )
      )
  end

  def scheduling_employee_ids
    schedulings.map(&:employee_id).uniq
  end

  def our_other_employee_ids
    find_alternative_employee_ids(scheduling_employee_ids)
  end


  def overlapping?(me, it)
    me != it &&
      me.employee_id &&
      it.employee_id &&
      (me.employee_id == it.employee_id ||
       it.represents_unavailability? && alternative_employee_ids(me).include?(it.employee_id)
      ) &&
      me.cover?(it)
  end

  def alternative_employee_ids(s)
    @alternative_employee_ids ||= Hash.new
    @alternative_employee_ids[s.employee_id] ||= find_alternative_employee_ids(s.employee_id)
  end

  def find_alternative_employee_ids(ids)
    user_ids = Employee.where(id: ids).pluck('DISTINCT user_id')
    Employee.where( user_id: user_ids).pluck('DISTINCT id')
  end


end
