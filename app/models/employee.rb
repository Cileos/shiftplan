class Employee < ActiveRecord::Base
  is_gravtastic

  has_many :employee_qualifications
  has_many :qualifications, :through => :employee_qualifications
  has_many :allocations

  validates_presence_of :first_name, :last_name

  named_scope :active, :conditions => { :active => true }
  named_scope :inactive, :conditions => { :active => false }
    
  class << self
    def find_by_name(name)
      find_by_first_name_and_last_name(*name.split(' '))
    end
  end

  def has_qualification?(qualification)
    qualifications.include?(qualification)
  end

  def possible_workplaces
    @possible_workplaces ||= qualifications.collect do |qualification|
      Workplace.for_qualification(qualification)
    end.flatten.uniq
  end

  def state
    active? ? 'active' : 'inactive'
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    @initials ||= begin
      initials = read_attribute(:initials)
      !initials.blank? ? initials : full_name.split(' ').map(&:first).join
    end
  end

  def gravatar_url_for_css(*args)
    gravatar_url(*args).gsub('&amp;', '&')
  end
end
