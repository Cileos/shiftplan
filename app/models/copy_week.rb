class CopyWeek
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
  include ActiveAttr::AttributeDefaults
  include Draper::ModelSupport

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

  def target_day
    (Date.new(target_year.to_i) + target_week.to_i.weeks).beginning_of_week
  end

  # TODO actually copy
  def save
    Plan.transaction do
      source_schedulings.each do |s|
        t = s.dup
        t.move_to_week_and_year target_week, target_year
        t.save!
      end
    end
  end

  def source_schedulings
    source_filter.records
  end

  def source_filter
    plan.schedulings.filter(week: source_week, cwyear: source_year)
  end
end

CopyWeekDecorator
