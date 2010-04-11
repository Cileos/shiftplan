class Employee < ActiveRecord::Base
  is_gravtastic
  acts_as_taggable

  belongs_to :account
  has_many :employee_qualifications
  has_many :qualifications, :through => :employee_qualifications
  has_many :allocations

  has_many :statuses

  validates_presence_of :first_name, :last_name

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
    def token_sql
      "SHA1(CONCAT('---', id, '---', created_at, '---')) = ?"
    end

    def find_by_token(token)
      first(:conditions => [token_sql, token])
    end

    def csv_fields
      @@csv_fields ||= %w(last_name first_name initials birthday active email phone street zipcode city token)
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

  def token
    Digest::SHA1.hexdigest("---#{id}---#{created_at.to_s(:db)}---")
  end
end
