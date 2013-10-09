class CopyWeek
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
  include ActiveAttr::AttributeDefaults
  include Draper::Decoratable

  attribute :plan
  attribute :source_year, type: Integer
  attribute :source_week, type: Integer
  attribute :target_year, type: Integer
  attribute :target_week, type: Integer

  validates_presence_of :plan, :source, :target
  validates_presence_of :source_year, :source_week
  validates_presence_of :target_year, :target_week

  def source
    "#{source_year}/#{source_week}"
  end

  def source=(new_source)
    if new_source =~ %r~^(\d+)/(\d+)$~
      self.source_year = $1.to_i
      self.source_week = $2.to_i
    end
  end

  def monday
    Date.commercial(target_year, target_week, 1)
  end

  def save
    Plan.transaction do
      source_schedulings.each do |s|
        t = s.dup
        t.move_to_week_and_year! target_week, target_year
      end
    end
  end

  def source_schedulings
    plan.filter(cwyear: source_year, week: source_week).records.reject do |s|
      s.previous_day.present?
    end
  end
end

CopyWeekDecorator
