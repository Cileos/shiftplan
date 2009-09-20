class Workplace < ActiveRecord::Base
  self.partial_updates = false

  has_many :workplace_requirements

  named_scope :active, :conditions => { :active => true }
  named_scope :inactive, :conditions => { :active => false }

  validates_presence_of :name

  acts_as_taggable_on :qualifications

  def required_quantity_for(qualification)
    workplace_requirements.detect { |wr| wr.qualification_id == qualification.id }.try(:quantity) || 1
  end

  def requirements=(requirements)
    requirements.each do |qualification_id, attributes|
      requirement = workplace_requirements.detect { |wr| wr.qualification_id == qualification_id.to_i } || workplace_requirements.build(:qualification_id => qualification_id)
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

  def color=(color)
    color = color.to_s if color
    write_attribute(:color, color.starts_with?('#') ? color[1..-1] : color)
  end
end
