# encapsulates parsing of quicky lines to enter timesspans and so on
class Quicky
  attr_accessor :start_hour, :end_hour
  def self.parse(*a)
    new.parse(*a)
  end

  def parse(input)
    if input =~ /^(\d{1,2})-(\d{1,2})$/
      self.start_hour =  $1.to_i
      self.end_hour = $2.to_i
    end
    self
  end

  def start_hours
    start_hour.hours
  end

  def end_hours
    end_hour.hours
  end

  def to_s
    "#{start_hour}-#{end_hour}"
  end
end