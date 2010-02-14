class Workplace < ActiveRecord::Base
  self.partial_updates = false # TODO do we still need that?

  belongs_to :account

  has_many :shifts
  has_many :workplace_requirements
  has_many :workplace_qualifications
  has_many :qualifications, :through => :workplace_qualifications

  scope :for_qualification, lambda { |qualification|
    {
      :joins => :workplace_qualifications,
      :conditions => ["qualification_id = ?", qualification.id]
    }
  }
  scope :active,   where(:active => true)
  scope :inactive, where(:active => false)

  validates_presence_of :name

  before_create :generate_color

  accepts_nested_attributes_for :workplace_requirements, :allow_destroy => true

  class << self
    def search(term)
      where(["name LIKE ?", "%#{term}%"])
    end
  end

  def needs_qualification?(qualification)
    qualifications.include?(qualification)
  end

  def required_quantity_for(qualification)
    workplace_requirements.detect { |wr| wr.qualification_id == qualification.id }.try(:quantity) || 1
  end

  def default_staffing
    workplace_requirements.sort_by(&:qualification_id).collect do |requirement|
      [requirement.qualification_id] * requirement.quantity
    end.flatten
  end

  # def requirements=(requirements)
  #   requirements.each do |qualification_id, attributes|
  #     requirement = workplace_requirements.detect { |wr| wr.qualification_id == qualification_id.to_i } || workplace_requirements.build(:qualification_id => qualification_id.to_i)
  #     requirement.quantity = attributes[:quantity].to_i
  #     requirement.save # FIXME
  #   end
  # end

  def state
    active? ? 'active' : 'inactive'
  end

  def color
    @color ||= begin
      color = read_attribute(:color)
      "##{color}" unless color.blank? || color.starts_with?('#')
    end
  end

  def form_values_json
    qualifications = Qualification.all.collect { |qualification| "'#{qualification.id}'" if needs_qualification?(qualification) }.compact.join(', ')
    json = <<-json
      {
        name: '#{name}',
        active: #{active?},
        default_shift_length: #{default_shift_length || 0},
        qualifications: [#{qualifications}]
      }
    json
    json.gsub("\n", ' ').strip
  end

  def workplace_requirements_json
    workplace_requirements_json = workplace_requirements.map do |requirement|
      next unless requirement.qualification
      <<-json
        {
          id: #{requirement.id},
          qualification: {
            id: #{requirement.qualification_id},
            name: '#{requirement.qualification.name}'
          },
          quantity: #{requirement.quantity}
        }
      json
    end.compact.join(', ')
    "[#{workplace_requirements_json}]".gsub("\n", ' ').strip
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
