class Account < ActiveRecord::Base
  has_many   :organizations
  has_many   :employees
  has_many   :users, through: :employees
  has_many   :invitations, through: :organizations
  has_many   :qualifications, order: 'name ASC'
  belongs_to :owner, class_name: 'Employee'
  has_many   :schedulings, through: :organizations
  has_many   :teams, through: :organizations

  include FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :name,
                  :organization_name,
                  :first_name,
                  :last_name,
                  :user_id,
                  :on_new_account

  attr_accessor :organization_name,
                :first_name,
                :last_name,
                :user_id,
                :on_new_account

  validates_format_of :name, with: Volksplaner::NameRegEx
  validates_presence_of :name

  # TODO extract to AccountCreation/Signup or similar
  with_options if: Proc.new { |a| a.on_new_account } do |on_new_account|
    on_new_account.validates_presence_of :organization_name,
                                         :first_name,
                                         :last_name,
                                         :user_id
    on_new_account.validates_format_of :organization_name, with: Volksplaner::NameRegEx
    on_new_account.validates_format_of :first_name, :last_name, with: Volksplaner::HumanNameRegEx, allow_nil: true
  end

  def user
    User.find(user_id)
  end

  def self.default_sorting
    order('UPPER(accounts.name) COLLATE "C"')
  end

  def to_s
    %Q~<Account #{id} "#{name}">~
  end

  def setup
    if persisted? and on_new_account
      organization = organizations.create!(:name => organization_name)
      organization.setup # creates the organization's blog
      e = employees.create! do |e|
        e.first_name  = first_name
        e.last_name   = last_name
        e.user_id     = user_id
        e.role        = 'owner'
      end
      organization.memberships.create!(employee: e)
    end
  end
end

AccountDecorator
