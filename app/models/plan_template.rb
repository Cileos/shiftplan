class PlanTemplate < ActiveRecord::Base
  belongs_to :organization
  has_many   :shifts, dependent: :destroy

  TEMPLATE_TYPES = ['weekbased']

  validates :name, :organization, :template_type, presence: true
  validates_uniqueness_of :name, scope: :organization_id
  validates_inclusion_of :template_type, in: TEMPLATE_TYPES

  def self.template_type_options
    @template_type_options ||= TEMPLATE_TYPES.map do |tt|
      [I18n.t("plan_templates.template_types.#{tt}"), tt]
    end
  end

  def self.default_sorting
    order(:name)
  end
end
