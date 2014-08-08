require 'spec_helper'

describe Setup do
  it 'needs first name for employee'
  it 'needs last name for employee'

  context 'execute!' do
    def execute(attrs={})
      build(:setup, attrs).execute!
    end

    it 'creates account' do
      expect { execute(account_name: 'Foo') }.
        to change { Account.where(name: 'Foo').count }.from(0).to(1)
    end

    it 'uses default name for account when left blank' do
      expect { execute(account_name: 'Foo') }.
        to change { Account.where(name: Setup.default_account_name).count }.from(0).to(1)
    end

    it 'creates organization' do
      expect { execute(organization_name: 'Foo') }.
        to change { Organization.where(name: 'Foo').count }.from(0).to(1)
    end

    it 'uses default name for organization when left blank' do
      expect { execute }.
        to change { Organization.where(name: Setup.default_organization_name).count }.from(0).to(1)
    end

    it 'creates a team for each name' do
      expect { execute(team_names: "Grün, Blau,Rot") }.
        to change { Team.count }.from(0).to(1)
    end

    it 'creates employee owning the account' do
      expect { execute(employee_first_name: 'Paul', employee_last_name: 'Panther') }.
        to change { Employee.where(first_name: 'Paul', last_name: 'Panther').count }.from(0).to(1)
    end

    it 'creates membership for the employee' do
      expect { execute }.
        to change { Membership.count }.from(0).to(1)
    end

    it 'creates plan with default name' do
      expect { execute }.
        to change { Plan.where(name: Setup.default_plan_name).count }.from(0).to(1)
    end
  end
end
