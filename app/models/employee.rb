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

  validates_presence_of :account_id
  validates_uniqueness_of :user_id, scope: :account_id, allow_nil: true
  validates_length_of :duplicates, is: 0,
    if: Proc.new { |e| e.sufficient_details_to_search_duplicates? and !e.force_duplicate? }

  before_validation :reset_duplicates
  after_save :update_or_create_membership

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
      memberships.find_by_organization_id(organization_id).try(:role)
    end
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
      m = find_or_build_membership
      if membership_role.to_s != 'owner'
        m.role = membership_role
      end
      m.save!
    end
  end

  def find_or_build_membership
    memberships.find_by_organization_id(organization_id) ||
      memberships.build(organization_id: organization_id)
  end

  def reset_duplicates
    @duplicates_search = @duplicates = nil
  end
end

EmployeeDecorator
