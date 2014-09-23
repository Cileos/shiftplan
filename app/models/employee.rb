class Employee < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Volksplaner::ShortcutAttribute

  mount_uploader :avatar, AvatarUploader

  attr_accessor :organization_id,
                :force_duplicate,
                :membership_role

  validates_presence_of :first_name, :last_name
  validates_numericality_of :weekly_working_time, allow_nil: true, greater_than_or_equal_to: 0
  validates_format_of :first_name, :last_name, with: Volksplaner::HumanNameRegEx, allow_nil: true

  belongs_to :user
  belongs_to :account
  has_one    :invitation
  has_one    :owned_account, class_name: 'Account', foreign_key: 'owner_id', inverse_of: :owner
  has_many   :posts, foreign_key: :author_id
  has_many   :comments
  has_many   :schedulings
  has_many   :organizations, through: :memberships
  has_many   :memberships
  has_many   :notifications, class_name: 'Notification::Base'

  has_many   :employee_qualifications
  has_many   :qualifications, through: :employee_qualifications

  has_many   :unavailabilities

  delegate :email, to: :user, allow_nil: true

  validates_presence_of :account_id
  validates_uniqueness_of :user_id, scope: :account_id, allow_nil: true
  validates_length_of :duplicates, is: 0,
    if: Proc.new { |e| e.sufficient_details_to_search_duplicates? and !e.force_duplicate? }
  validates_inclusion_of :membership_role, in: %w(owner), if: :owner?

  before_validation :reset_duplicates
  after_save :update_or_create_membership

  attr_accessor :invite
  accepts_nested_attributes_for :invitation

  def notifications_for_dashboard
    notifications.for_dashboard
  end

  def self.order_by_name
    order('last_name, first_name')
  end

  def self.default_sorting
    order_by_name.order(:id)
  end

  def owner?
    owned_account.present?
  end

  def active?
    user && user.confirmed?
  end

  def invited?
    invitation.present?
  end

  def planable?
    ! current_membership.suspended?
  end
  alias_method :planable, :planable?

  def planable=(new_val)
    current_membership.suspended = new_val.to_i != 1
  end

  def duplicates_search
    @duplicates_search ||= EmployeeSearch.duplicates_for_employee(self)
  end

  def sufficient_details_to_search_duplicates?
    duplicates_search.search?
  end

  def duplicates
    @duplicates ||= duplicates_search.results
  end

  def name
    %Q~#{first_name} #{last_name}~
  end

  def name=(new_name)
    if new_name =~ /^(\w+)\s+(\w.*)$/
      self.first_name = $1
      self.last_name = $2.strip
    end
  end

  def last_and_first_name
    %Q~#{last_name}, #{first_name}~
  end

  def membership_role
    if organization_id
      @membership_role ||
        current_membership.try(:role)
    end
  end

  def membership_for_organization(org)
    org = org.id if org.is_a?(ActiveRecord::Base)
    raise ArgumentError, "no organization/id given" if org.nil?
    memberships.where(organization_id: org).first
  end

  def current_membership
    @current_membership ||= membership_for_organization(organization_id) || memberships.build(organization_id: organization_id)
  end


  def force_duplicate?
    force_duplicate.in?(['1', 1, true])
  end

  def to_s
    %Q~<Employee #{id || 'new'} #{name.inspect} (#{weekly_working_time.presence || ''}) [#{account.try(:name)}]>~
  end

  def inspect
    to_s
  end

  private

  def update_or_create_membership
    if organization_id
      m = current_membership
      if membership_role.to_s != 'owner'
        m.role = membership_role
      end
      m.save!
    end
  end

  def reset_duplicates
    @duplicates_search = @duplicates = nil
  end
end

EmployeeDecorator
