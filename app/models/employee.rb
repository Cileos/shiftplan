class Employee < ActiveRecord::Base
  is_gravtastic!

  has_many :allocations

  validates_presence_of :first_name, :last_name

  named_scope :active, :conditions => { :active => true }
  named_scope :inactive, :conditions => { :active => false }

  acts_as_taggable_on :qualifications

  def possible_workplaces
    @possible_workplaces ||= qualifications.collect do |qualification|
      Workplace.tagged_with(qualification.name, :on => :qualifications)
    end.flatten.uniq
  end

  def state
    active? ? 'active' : 'inactive'
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
