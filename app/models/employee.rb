class Employee < ActiveRecord::Base
  include Gravtastic
  is_gravtastic

  acts_as_taggable

  belongs_to :account
  has_many :employee_qualifications
  has_many :qualifications, :through => :employee_qualifications
  has_many :allocations

  has_many :statuses

  validates_presence_of :first_name, :last_name
  
  before_validation :generate_token

  scope :active, where(:active => true)
  scope :inactive, where(:active => false)

  scope :for_qualification, lambda { |*args|
    qualification, options = *args
    (options || {}).merge({
      :joins => :employee_qualifications,
      :conditions => ["qualification_id = ?", qualification.id]
    })
  }

  class << self
    def csv_fields
      @@csv_fields ||= %w(last_name first_name initials birthday active email phone street zipcode city tag_list token)
    end

    def find_by_name(name)
      find_by_first_name_and_last_name(*name.split(' '))
    end

    def search(term)
      where(["CONCAT(first_name, last_name, cached_tag_list) LIKE ?", "%#{term}%"])
    end
  end

  def has_qualification?(qualification)
    qualifications.include?(qualification)
  end

  def qualified_workplaces
    @qualified_workplaces ||= qualifications.collect do |qualification|
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
    gravatar_url(*args).gsub('&amp;', '&').html_safe
  end

  def form_values_json
    qualifications = Qualification.all.collect { |qualification| "'#{qualification.id}'" if has_qualification?(qualification) }.compact.join(', ')
    json = <<-json
      {
        first_name: '#{first_name}',
        last_name: '#{last_name}',
        active: #{active?},
        qualifications: [#{qualifications}],
        tag_list: '#{tag_list}',
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

  def generate_token
    self.token ||= Digest::SHA1.hexdigest(%(
      #{rand}cebf65f392a1eed541ecfa331dcfa502dfc67108fcbfdfb517e61be144326
      bb9e04b93f95c91ed636399bc7db6f0c0cd8a6951384afe793a08873ebdfca4e841
    ))
  end
end
