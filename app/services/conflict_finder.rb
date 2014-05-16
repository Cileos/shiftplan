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
      found = [].tap do |conflicts|

        other_schedulings.each do |it|
          if overlapping?(me, it)
            conflicts << it
          end
        end

        unavailabilities.each do |it|
          if overlapping?(me, it)
            conflicts << it
          end
        end

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

  def other_schedulings
    return [] if schedulings.empty?
    return @other_schedulings if @other_schedulings

    klass = schedulings.first.class
    s = klass.arel_table
    @other_schedulings = klass.
      between(*search_period).
      where(
        s[:employee_id].in(scheduling_employee_ids).or(
          s[:represents_unavailability].eq(true).and(
            s[:employee_id].in(our_other_employee_ids)
          )
        )
      )
  end

  def unavailabilities
    return [] if schedulings.empty?
    return @unavailabilities if @unavailabilities

    u = Unavailability.arel_table

    @unavailabilities = Unavailability.
      between(*search_period).
      where(
        u[:employee_id].in(our_other_employee_ids).or(
          u[:user_id].in(our_user_ids)
        )
      )
  end

  def scheduling_employee_ids
    schedulings.map(&:employee_id).uniq
  end

  def our_other_employee_ids
    @our_other_employee_ids ||= find_alternative_employee_ids(scheduling_employee_ids)
  end

  def our_user_ids
    @our_user_ids ||= Employee.where(id: scheduling_employee_ids).pluck('DISTINCT user_id')
  end

  def search_period
    [
      schedulings.map(&:starts_at).min - 1.day,
      schedulings.map(&:ends_at).max + 1.day
    ]
  end


  def overlapping?(me, it)
    case it
    when Scheduling
      me != it &&
        me.employee_id &&
        it.employee_id &&
        (me.employee_id == it.employee_id ||
         it.represents_unavailability? && alternative_employee_ids(me).include?(it.employee_id)
        ) &&
        me.cover?(it)
    when Unavailability
      me != it &&
        me.employee_id &&
        it.employee_id &&
        it.employee_id == me.employee_id &&
        me.cover?(it)
    else
      raise ArgumentError, "cannot determine if overlapping with #{it.class}"
    end
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
