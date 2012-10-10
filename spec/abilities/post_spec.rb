require 'spec_helper'
require "cancan/matchers"

shared_examples "an employee who can create and read posts" do
  it "should be able to create posts" do
    should be_able_to(:create, build(:post, blog: blog))
  end
  it "should be able to read posts" do
    should be_able_to(:read, create(:post, blog: blog, author: another_employee))
  end
end

shared_examples "an employee who can destroy and update his own posts" do
  it "should be able to update posts" do
    should be_able_to(:update, create(:post, blog: blog, author: employee))
  end
  it "should be able to destroy posts" do
    should be_able_to(:destroy, create(:post, blog: blog, author: employee))
  end
end

shared_examples "an employee who can not update and destroy posts of other employees" do
  it "should not be able to update posts" do
    should_not be_able_to(:update, create(:post, blog: blog, author: another_employee))
  end
  it "should not be able to destroy posts" do
    should_not be_able_to(:destroy, create(:post, blog: blog, author: another_employee))
  end
end

shared_examples "an employee who can not manage posts" do
  it "should not be able to create posts" do
    should_not be_able_to(:create, build(:post, blog: other_blog))
  end
  it "should not be able to read posts" do
    should_not be_able_to(:read, create(:post, blog: other_blog))
  end
  it "should not be able to update posts" do
    should_not be_able_to(:update, create(:post, blog: other_blog))
  end
  it "should not be able to destroy posts" do
    should_not be_able_to(:destroy, create(:post, blog: other_blog))
  end
end

shared_examples "an employee managing posts" do
  # Another employee of same account/same organization who can be the author of posts, too.
  # The employee should not be able to update or destroy posts of another_employee.
  let(:another_employee) { create(:employee, account: account) }
  let(:membership) { create(:membership, employee: another_employee, organization: organization) }

  before(:each) do
    membership
  end

  it_behaves_like "an employee who can destroy and update his own posts"
  context "for own organizations" do
    it_behaves_like "an employee who can create and read posts"
    it_behaves_like "an employee who can not update and destroy posts of other employees"
  end
  context "for other organizations" do
    it_behaves_like "an employee who can not manage posts"
  end
end

describe "Post permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }
  let(:account) { create(:account)}
  let(:organization) { create(:organization, account: account) }
  let(:blog) { create(:blog, organization: organization) }

  let(:other_account) { create(:account)}
  let(:other_organization) { create(:organization, account: other_account) }
  let(:other_blog) { create(:blog, organization: other_organization) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "An owner" do
    it_behaves_like "an employee managing posts" do
      let(:employee) { create(:employee_owner, account: account, user: user) }
    end
  end

  context "A planner" do
    it_behaves_like "an employee managing posts" do
      let(:employee) { create(:employee_planner, account: account, user: user) }
    end
  end

  context "An employee" do
    before(:each) do
      membership
    end

    it_behaves_like "an employee managing posts" do
      let(:employee) { create(:employee, account: account, user: user) }
      let(:membership) { create(:membership, employee: employee, organization: organization) }

      # The employee only is member of organization but not of
      # other_organization.  Therefore he will not be able to manage posts for
      # other_blog which belongs to other_organization.
      let(:other_organization) { create(:organization, account: account) }
      let(:other_blog) { create(:blog, organization: other_organization) }
    end
  end

  context "As an user without employee(not possible but for the case)" do
    it_behaves_like "an employee who can not manage posts" do
      let(:employee) { nil }

      let(:other_organization) { create(:organization, account: account) }
      let(:other_blog) { create(:blog, organization: other_organization) }
    end
  end
end
