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

shared_examples "an employee managing posts" do
  # Another employee of same account/same organization who can be the author of posts, too.
  # The employee should not be able to update or destroy posts of another_employee.
  let(:another_employee) { create(:employee, account: account) }
  let!(:another_membership) { create(:membership, employee: another_employee, organization: organization) }

  it_behaves_like "an employee who can destroy and update his own posts"
  context "for own organizations" do
    it_behaves_like "an employee who can create and read posts"
    it_behaves_like "an employee who can not update and destroy posts of other employees"
  end
  context "for other organizations" do
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
end

shared_examples "an employee without membership" do
  let(:another_organization) { create(:organization, account: account) }
  let(:another_blog) do
    create(:blog, organization: another_organization)
  end

  it "should not be able to create posts" do
    should_not be_able_to(:create, build(:post, blog: another_blog))
  end
  it "should not be able to read posts" do
    should_not be_able_to(:read, create(:post, blog: another_blog))
  end
  it "should not be able to update posts" do
    should_not be_able_to(:update, create(:post, blog: another_blog))
  end
  it "should not be able to destroy posts" do
    should_not be_able_to(:destroy, create(:post, blog: another_blog))
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
    before(:each) do
      # The planner role is set on the membership, so a planner can only be
      # a planner for a certain membership/organization.
      # Simulate CanCan's current_ability method by setting the current
      # membership manually here.
      user.current_membership = membership
    end

    let(:employee) { create(:employee, account: account, user: user) }
    let(:membership) do
      create(:membership,
        role: 'planner',
        employee: employee,
        organization: organization)
    end

    it_behaves_like "an employee managing posts"

    it_behaves_like "an employee without membership"
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }
    let!(:membership) { create(:membership, employee: employee, organization: organization) }

    it_behaves_like "an employee managing posts" do
      # The employee only is member of organization but not of
      # other_organization.  Therefore he will not be able to manage posts for
      # other_blog which belongs to other_organization.
      let(:other_organization) { create(:organization, account: account) }
      let(:other_blog) { create(:blog, organization: other_organization) }
    end

    it_behaves_like "an employee without membership"
  end

  context "As an user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it "should not be able to create posts" do
      should_not be_able_to(:create, build(:post, blog: blog))
    end
    it "should not be able to read posts" do
      should_not be_able_to(:read, create(:post, blog: blog))
    end
    it "should not be able to update posts" do
      should_not be_able_to(:update, create(:post, blog: blog))
    end
    it "should not be able to destroy posts" do
      should_not be_able_to(:destroy, create(:post, blog: blog))
    end
  end
end
