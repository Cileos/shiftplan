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
    Employee.all.each do |employee|
      employee.should_not be_nil
      employee.account.should_not be_nil
      employee.qualifications.should_not be_empty
    end
  end

  it "should create Workplaces w/ workplace_requirements" do
    Workplace.all.each do |workplace|
      workplace.should_not be_nil
      workplace.account.should_not be_nil
      workplace.workplace_requirements.should_not be_empty
    end
  end

  it "should create a Plan w/ shifts" do
    Plan.all.each do |plan|
      plan.should_not be_nil
      plan.account.should_not be_nil
      plan.shifts.should_not be_empty
    end
  end
end
