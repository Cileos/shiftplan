class Workplace < ActiveRecord::Base
  self.partial_updates = false

  belongs_to :location
  has_many :workplace_requirements

  named_scope :active, :conditions => { :active => true }
  named_scope :inactive, :conditions => { :active => false }

  validates_presence_of :name

  acts_as_taggable_on :qualifications

  before_create :generate_color

  def required_quantity_for(qualification)
    workplace_requirements.detect { |wr| wr.qualification_id == qualification.id }.try(:quantity) || 1
  end

  def requirements=(requirements)
    requirements.each do |qualification_id, attributes|
      requirement = workplace_requirements.detect { |wr| wr.qualification_id == qualification_id.to_i } || workplace_requirements.build(:qualification_id => qualification_id.to_i)
      requirement.quantity = attributes[:quantity].to_i
      requirement.save # FIXME
    end
  end

  def state
    active? ? 'active' : 'inactive'
  end

  def color
    @color ||= begin
      color = read_attribute(:color)
      "##{color}" unless color.blank? || color.starts_with?('#')
    end
  end

  protected

    def generate_color
      step_width = 30
      hue = Workplace.count * step_width # FIXME: adjust starting point for > 12 workplaces
      saturation = 0.45
      value = 1

      color = Color.rgb_to_hex(*Color.hsv_to_rgb(hue, saturation, value))
      write_attribute(:color, color)
    end
end
