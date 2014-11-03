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

  def self.assembles_from_year_and_week(name)
    file, line = caller.first.split(':', 2)
    line = line.to_i
    module_eval <<-EORUBY, file, line
      def #{name}
        "\#{#{name}_year}/\#{#{name}_week}"
      end

      def #{name}=(new_#{name})
        if new_#{name} =~ %r~^(\d+)/(\d+)$~
          self.#{name}_year = $1.to_i
          self.#{name}_week = $2.to_i
        end
      end
    EORUBY
  end

  assembles_from_year_and_week :source
  assembles_from_year_and_week :target

  def monday
    Date.commercial(target_year, target_week, 1)
  end

  def save
    Plan.transaction do
      source_schedulings.each do |s|
        t = s.dup
        t.comments_count = 0 # do not copy the comments_count of the original
        t.move_to_week_and_year! target_week, target_year
        created_schedulings << t
      end
    end
  end

  def created_schedulings
    @created_schedulings ||= []
  end

  def source_schedulings
    plan.filter(cwyear: source_year, week: source_week).records
  end
end

CopyWeekDecorator
