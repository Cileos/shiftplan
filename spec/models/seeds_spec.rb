require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Seeds" do
  before(:each) do
    load("#{Rails.root}/db/seeds.rb")
  end

  it "should create an Account with a member" do
    account = Account.first
    account.should_not be_nil
    account.users.should_not be_empty
  end

  it "should create Employees w/ qualifications" do
    employee = Employee.first
    employee.should_not be_nil
    employee.qualifications.should_not be_empty
  end

  it "should create Workplaces w/ workplace_requirements" do
    workplace = Workplace.first
    workplace.should_not be_nil
    workplace.workplace_requirements.should_not be_empty
  end

  it "should create a Plan w/ shifts" do
    plan = Plan.first
    plan.should_not be_nil
    plan.shifts.should_not be_empty
  end
end