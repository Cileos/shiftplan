require 'spec_helper'
require "cancan/matchers"

shared_examples "an employee who can read comments" do
  it "I should be able to read comments on posts" do
    comment = Comment.build_from(post, some_employee, body: 'some text')
    should be_able_to(:read, comment)
  end
  it "I should be able to read comments on schedulings" do
    comment = Comment.build_from(scheduling, some_employee, body: 'some text')
    should be_able_to(:read, comment)
  end
end

shared_examples "an employee who can create comments" do
  it "I should be able to create comments on posts" do
    comment = Comment.build_from(post, employee, body: 'some text')
    should be_able_to(:create, comment)
  end
  it "I should be able to create comments on schedulings" do
    comment = Comment.build_from(scheduling, employee, body: 'some text')
    should be_able_to(:create, comment)
  end
end

shared_examples "an employee who can destroy his own comments" do
  it "I should be able to destroy my own comments on posts" do
    comment = Comment.build_from(post, employee, body: 'some text')
    should be_able_to(:destroy, comment)
  end
  it "I should be able to destroy my own comments on schedulings" do
    comment = Comment.build_from(scheduling, employee, body: 'some text')
    should be_able_to(:destroy, comment)
  end
end

shared_examples "an employee who can not destroy comments which are not his own" do
  it "I should not be able to destroy comments on posts having an author different than me" do
    comment = Comment.build_from(post, some_employee, body: 'some text')
    should_not be_able_to(:destroy, comment)
  end
  it "I should not be able to destroy comments on schedulings having an author different than me" do
    comment = Comment.build_from(scheduling, some_employee, body: 'some text')
    should_not be_able_to(:destroy, comment)
  end
end

shared_examples "an employee who can not update comments" do
  # updating: comments are not updatable at the moment
  it "I should not be able to update comments on posts, even my own" do
    comment = Comment.build_from(post, employee, body: 'some text')
    should_not be_able_to(:update, comment)
  end
  it "I should not be able to update comments on schedulings, even my own" do
    comment = Comment.build_from(scheduling, employee, body: 'some text')
    should_not be_able_to(:update, comment)
  end
end

shared_examples "an employee who can not read comments" do
  it "I should not be able to read comments on posts" do
    # other_post belongs to other account
    comment = Comment.build_from(other_post, other_employee, body: 'some text')
    should_not be_able_to(:read, comment)
  end

  it "I should not be able to read comments on schedulings" do
    # other_scheduling belongs to other account
    comment = Comment.build_from(other_scheduling, other_employee, body: 'some text')
    should_not be_able_to(:read, comment)
  end
end

shared_examples "an employee who can not create comments" do
    # other_post belongs to other account
  it "I should not be able to create comments on posts of different accounts" do
    comment = Comment.build_from(other_post, employee, body: 'some text')
    should_not be_able_to(:create, comment)
  end
  it "I should not be able to create comments on schedulings of different accounts" do
    # other_scheduling belongs to other account
    comment = Comment.build_from(other_scheduling, employee, body: 'some text')
    should_not be_able_to(:create, comment)
  end
end

shared_examples "a commenting employee" do
  context "for own accounts" do
    it_behaves_like "an employee who can read comments"
    it_behaves_like "an employee who can create comments"
    it_behaves_like "an employee who can destroy his own comments"
    it_behaves_like "an employee who can not destroy comments which are not his own"
    it_behaves_like "an employee who can not update comments"
  end

  context "for other accounts" do
    it_behaves_like "an employee who can not read comments"
    it_behaves_like "an employee who can not create comments"
  end
end

describe "Comment permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }

  let(:account) { create(:account)}
  let(:organization) { create(:organization, account: account) }
  let(:some_employee) { create(:employee, account: account) }
  let(:some_membership) { create(:membership, employee: some_employee, organization: organization) }

  let(:blog) { create(:blog, organization: organization) }
  let(:post) { create(:post, blog: blog) }
  let(:plan) { create(:plan, organization: organization) }
  let(:scheduling) { create(:scheduling, plan: plan) }

  let(:other_account) { create(:account) }
  let(:other_organization) { create(:organization, account: other_account) }
  let(:other_employee) { create(:employee, account: other_account) }
  let(:other_membership) { create(:membership, employee: other_employee, organization: other_organization) }

  let(:other_blog) { create(:blog, organization: other_organization) }
  let(:other_post) { create(:post, blog: other_blog) }
  let(:other_plan) { create(:plan, organization: other_organization) }
  let(:other_scheduling) { create(:scheduling, plan: other_plan) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "An owner" do
    it_behaves_like "a commenting employee" do
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

    it_behaves_like "a commenting employee" do
      let(:employee) { create(:employee, account: account, user: user) }
      let(:membership) do
        create(:membership,
          role: 'planner',
          employee: employee,
          organization: organization)
      end
    end
  end

  context "An employee" do
    it_behaves_like "a commenting employee" do
      let(:employee) { create(:employee, account: account, user: user) }
      # An "normal" employee needs a membership for an organization to do things.
      # This is different from planners or owners which do not need a membership but
      # just the role "planner" or "owner" and belong to the acccount.
      let!(:membership) { create(:membership, employee: employee, organization: organization) }
    end
  end
end

