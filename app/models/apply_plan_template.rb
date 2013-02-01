class ApplyPlanTemplate
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
  include ActiveAttr::AttributeDefaults
  include Draper::ModelSupport

  attribute :plan
  attribute :plan_template
  attribute :target_year, type: Integer
  attribute :target_week, type: Integer

  validates_presence_of :plan, :plan_template
  validates_presence_of :target_year, :target_week

  # # TODO
  def save
  end

  def target_day
    (Date.new(target_year.to_i) + target_week.to_i.weeks).beginning_of_week
  end
end

ApplyPlanTemplateDecorator
