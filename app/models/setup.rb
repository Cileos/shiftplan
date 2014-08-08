class Setup < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :employee_first_name,
                        :employee_last_name,
                        on: :update

  validates_format_of :account_name, with: Volksplaner::NameRegEx, allow_blank: true
  validates_format_of :organization_name, with: Volksplaner::NameRegEx, allow_blank: true
  validates_format_of :employee_first_name, :employee_last_name, with: Volksplaner::HumanNameRegEx, allow_blank: true

  attr_reader :plan

  def execute!
    transaction do
      Account.create!(name: account_name).tap do |account|
        organization = Organization.create!(name: organization_name, account: account)
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
  end

  def account_name
    super.presence || self.class.default_account_name
  end

  def organization_name
    super.presence || self.class.default_organization_name
  end

  def plan_name
    self.class.default_plan_name
  end

  def team_name_list
    (team_names || '').split(',').map(&:strip)
  end

  class << self
    def default_account_name
      "Meine Firma"
    end

    def default_organization_name
      "Meine Organisation"
    end

    def default_plan_name
      "Mein erster Plan"
    end
  end
end
