require 'spec_helper'

describe Setup do
  context 'on intial creation' do
    it 'may be completely blank' do
      described_class.new.should be_valid
    end
  end

  context 'on update' do
    let(:setup) { create :setup }
    it 'is valid from factory' do
      setup.should be_valid
    end
    it 'needs first name for employee' do
      setup.employee_first_name = nil
      setup.should_not be_valid
    end
    it 'needs last name for employee' do
      setup.employee_last_name = nil
      setup.should_not be_valid
    end

  end

  context 'execute!' do
    def execute(attrs={})
      @setup = build(:setup, attrs)
      @setup.execute!
    end
    let(:account)      { Account.first }
    let(:organization) { Organization.first }
    let(:employee)     { Employee.first }
    let(:membership)   { Membership.find_by(organization: organization, employee: employee) }
    let(:teams)        { Team.all }
    let(:plan)         { Plan.first }

    it 'creates account' do
      expect { execute(account_name: 'Foo') }.
        to change { Account.where(name: 'Foo').count }.from(0).to(1)
    end

    it 'uses default name for account when left blank' do
      expect { execute }.
        to change { Account.where(name: Setup.default_account_name).count }.from(0).to(1)
    end

    it 'creates organization' do
      expect { execute(organization_name: 'Foo') }.
        to change { Organization.where(name: 'Foo').count }.from(0).to(1)

      organization.account.should == account
    end

    it 'uses default name for organization when left blank' do
      expect { execute }.
        to change { Organization.where(name: Setup.default_organization_name).count }.from(0).to(1)

      organization.account.should == account
    end

    it 'creates a team for each name' do
      expect { execute(team_names: "Grün, Blau,Rote Gruppe") }.
        to change { Team.count }.from(0).to(3)

      teams.each do |team|
        team.organization.should == organization
      end
      teams.map(&:name).sort.should == ['Blau', 'Grün', 'Rote Gruppe']
    end

    it 'creates employee owning the account' do
      expect { execute(employee_first_name: 'Paul', employee_last_name: 'Panther') }.
        to change { Employee.where(first_name: 'Paul', last_name: 'Panther').count }.from(0).to(1)

      account.owner.should == employee
    end

    it 'creates membership for the employee' do
      expect { execute }.
        to change { Membership.count }.from(0).to(1)

      # is this still neccessary?
      #membership.role.should == 'owner'
    end

    it 'creates plan with default name' do
      expect { execute }.
        to change { Plan.where(name: Setup.default_plan_name).count }.from(0).to(1)

      plan.organization.should == organization

      # need to access it for redirection
      @setup.plan.should == plan
    end
  end
end
