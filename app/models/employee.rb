class Employee < ActiveRecord::Base
  is_gravtastic

  belongs_to :account
  has_many :employee_qualifications
  has_many :qualifications, :through => :employee_qualifications
  has_many :allocations

  has_many :statuses

  validates_presence_of :first_name, :last_name

  scope :active, where(:active => true)
  scope :inactive, where(:active => false)

  scope :for_qualification, lambda { |qualification|
    {
      :joins => :employee_qualifications,
      :conditions => ["qualification_id = ?", qualification.id]
    }
  }

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

  def form_values_json
    qualifications = Qualification.all.collect { |qualification| "'#{qualification.id}'" if has_qualification?(qualification) }.compact.join(', ')
    json = <<-json
      {
        first_name: '#{first_name}',
        last_name: '#{last_name}',
        active: #{active?},
        qualifications: [#{qualifications}],
        email: '#{email}',
        phone: '#{phone}',
        street: '#{street}',
        zipcode: '#{zipcode}',
        city: '#{city}',
        birthday_1i: '#{birthday.try(:year)}',
        birthday_2i: '#{birthday.try(:mon)}',
        birthday_3i: '#{birthday.try(:mday)}'
      }
    json
    json.gsub("\n", ' ').strip
  end
end
