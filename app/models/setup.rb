class Setup < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :employee_first_name,
                        :employee_last_name,
                        on: :update

  validates_format_of :account_name, with: Volksplaner::NameRegEx, allow_blank: true
  validates_format_of :organization_name, with: Volksplaner::NameRegEx, allow_blank: true
  validates_format_of :employee_first_name, :employee_last_name, with: Volksplaner::HumanNameRegEx, allow_blank: true
  validates_format_of :team_names, with: Volksplaner::ListOfNamesRegEx, allow_blank: true

  validates_inclusion_of :time_zone_name, in: ActiveSupport::TimeZone.all.map(&:name), allow_blank: true

  attr_reader :plan

  def execute!
    account = nil # frak scope
    transaction do
      account = Account.create!(
        name: account_name_or_default,
        time_zone_name: time_zone_name).tap do |account|

        organization = Organization.create!(name: organization_name_or_default, account: account)
        organization.setup # creates the organization's blog
        e = user.employees.create! do |e|
          e.first_name  = employee_first_name
          e.last_name   = employee_last_name
          e.account     = account
        end
        # make the owner member of the first organization
        e.memberships.create!(organization: organization)
        account.owner_id = e.id
        account.save!

        team_name_list.each do |team_name|
          organization.teams.create! name: team_name
        end

        @plan = organization.plans.create!(name: plan_name)

        # We don't need the setup data anymore, would block the user from
        # visiting her dashboard
        destroy! if persisted?
      end
    end

    MarketingMailer.account_was_set_up(account).deliver
  end

  def account_name_or_default
    account_name.presence || self.class.default_account_name
  end

  def organization_name_or_default
    organization_name.presence || self.class.default_organization_name
  end

  def plan_name
    self.class.default_plan_name
  end

  def team_name_list
    (team_names || '').split(',').map(&:strip).reject(&:blank?)
  end

  class << self
    def default_account_name
      translate_default 'account_name'
    end

    def default_organization_name
      translate_default 'organization_name'
    end

    def default_plan_name
      translate_default 'plan_name'
    end

    def translate_default(field)
      I18n.translate field, scope: 'activerecord.defaults.setup'
    end
  end
end
