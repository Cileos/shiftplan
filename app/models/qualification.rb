class Qualification < ActiveRecord::Base
  belongs_to :account

  has_many :employee_qualifications
  has_many :employees, :through => :employee_qualifications

  before_create :generate_color

  default_scope :order => "name ASC"

  def possible_workplaces
    @possible_workplaces ||= Workplace.for_qualification(self)
  end

  def color
    @color ||= begin
      color = read_attribute(:color)
      "##{color}" unless color.blank? || color.starts_with?('#')
    end
  end

  def form_values_json
    "{ name: '#{name}' }"
  end

  protected

    def generate_color
      step_width = 30
      hue = 15 + Qualification.maximum('id').to_i * step_width # FIXME: adjust starting point for > 12 qualifications
      saturation = 0.75
      value = 1

      color = Color.rgb_to_hex(*Color.hsv_to_rgb(hue, saturation, value))
      write_attribute(:color, color)
    end
end
