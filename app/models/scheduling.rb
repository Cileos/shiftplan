class Scheduling < ActiveRecord::Base
  belongs_to :plan
  belongs_to :employee

  validates :starts_at, :ends_at, :plan, :presence => true

  attr_accessor :day
  attr_accessor :quicky


  private
  before_validation :parse_quicky

  def parse_quicky
    if quicky.present?
      if parsed = Quicky.parse(quicky)
        self.starts_at = plan.day_at(day) + parsed.start_hours
        self.ends_at = plan.day_at(day) + parsed.end_hours
        self.quicky = parsed.to_s # clean the entered quicky
      end
    end
  end

end
