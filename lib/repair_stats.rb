# Helps tracking changes while chaning state.
#
#   stats = RepairStats.new do |s|
#     s.dim "Number of People { Person.count }
#     s.dim "Number of Cats  { Cat.count }
#   end
#
#   stats.run do
#     Cat.all.each(&:eat_masters!)
#   end
#
# will puts something like this to STDERR (numbers in Billion):
#
#   Number of People: 7 => 2 (-5)
#   Number of Cats: 4 => 4.1 (0.1)
#
# Interpretation: Eating people makes cats horny.
class RepairStats
  attr_accessor :befores, :afters, :dimensions

  # Can give dimensions as Hash of String => Proc
  def initialize(dimensions={})
    dimensions.each do |name,plock|
      raise "key should be a human readable name" unless name.is_a?(String)
      raise "value should be a Proc, returning the value" unless plock.respond_to?(:call)
    end
    @dimensions = dimensions
    yield self if block_given?
  end

  # Define a dimension to measure while running.
  def dimension(name, &plock)
    dimensions[name] = plock
  end
  alias_method :dim, :dimension

  # Wrap your ocde in a block of this. Pass `true` if you really want to persist the changes
  def run(really=false)
    ActiveRecord::Base.transaction do
      self.befores = take_measurement
      yield
      self.afters = take_measurement
      puts_diff

      raise "just testing" unless really
    end
  end

  alias_method :measure, :run

  def puts_diff
    befores.each do |name, bef|
      aft = afters[name]

      diff = if bef.is_a?(Numeric)
               "(#{aft - bef})"
             else
               ''
             end


      STDERR.puts %Q~#{name}:  #{bef} -> #{aft} #{diff}~
    end
  end

  private
  def take_measurement
    dimensions.inject({}) do |coll, (name, plock)|
      coll[name] = plock.call
      coll
    end
  end
end

