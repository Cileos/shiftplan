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

  validates_presence_of :plan, :source_string, :target_string
  validates_presence_of :source_year, :source_week
  validates_presence_of :target_year, :target_week

  YearAndWeekRE = %r~^(\d+)/(\d+)$~

  class IsoWeekString < String
    def iso8601
      if self =~ YearAndWeekRE
        Date.commercial($1.to_i, $2.to_i, 1).iso8601
      end
    end
  end

  def self.assembles_from_year_and_week(name)
    attr_name = "#{name}_string"
    module_eval <<-EORUBY, __FILE__, __LINE__
      def #{attr_name}
        IsoWeekString.new "\#{#{name}_year}/\#{#{name}_week}"
      end

      def #{attr_name}=(new_string)
        if new_string =~ YearAndWeekRE
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
        # spanning in from previous week will be in previous of target_week
        week = s.starts_at.cweek < source_week ? target_week - 1 : target_week
        t.move_to_week_and_year! week, target_year
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
