require 'spec_helper'
require "cancan/matchers"

describe "Post permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { Factory(:user) }
  let(:organization) { Factory(:organization) }
  let(:blog) { Factory(:blog, organization: organization) }
  let(:some_employee) { Factory(:employee, organization: organization) }  

  let(:another_organization) { Factory(:organization) }
  let(:another_blog) { Factory(:blog, organization: another_organization) }
  let(:another_employee) { Factory(:employee, organization: another_organization) }  

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "As an owner" do
    let(:employee) { Factory(:owner, organization: organization, user: user) }
    
    context "for my own organization" do
      it "I should not be able to update posts having an author different than me" do
        should_not be_able_to(:update, Factory(:post, blog: blog, author: some_employee))
      end
    end

    context "for other organizations" do
      it "should not be able to read posts" do
        should_not be_able_to(:read, Factory(:post, blog: another_blog, author: another_employee))
      end

      it "should not be able to update posts" do
        should_not be_able_to(:update, Factory(:post, blog: another_blog, author: another_employee))
      end

      it "should not be able to create schedulings" do
        should_not be_able_to(:create, Factory.build(:post, blog: another_blog, author: another_employee))
      end

      it "should not be able to destroy schedulings" do
        should_not be_able_to(:destroy, Factory(:post, blog: another_blog, author: another_employee))
      end
    end
  end

  context "As a planner" do
    let(:employee) { Factory(:employee, organization: organization, user: user) }
    
    context "for my own organization" do
      it "I should not be able to update posts having an author different than me" do
        should_not be_able_to(:update, Factory(:post, blog: blog, author: some_employee))
      end
    end

    context "for other organizations" do
      it "should not be able to read posts" do
        should_not be_able_to(:read, Factory(:post, blog: another_blog, author: another_employee))
      end

      it "should not be able to update posts" do
        should_not be_able_to(:update, Factory(:post, blog: another_blog, author: another_employee))
      end

      it "should not be able to create schedulings" do
        should_not be_able_to(:create, Factory.build(:post, blog: another_blog, author: another_employee))
      end

      it "should not be able to destroy schedulings" do
        should_not be_able_to(:destroy, Factory(:post, blog: another_blog, author: another_employee))
      end
    end
  end

  context "As an employee" do
    let(:employee) { Factory(:employee, organization: organization, user: user) }
    
    context "for my own organization" do
      it "I should not be able to update posts having an author different than me" do
        should_not be_able_to(:update, Factory(:post, blog: blog, author: some_employee))
      end
    end

    context "for other organizations" do
      it "should not be able to read posts" do
        should_not be_able_to(:read, Factory(:post, blog: another_blog, author: another_employee))
      end

      it "should not be able to update posts" do
        should_not be_able_to(:update, Factory(:post, blog: another_blog, author: another_employee))
      end

      it "should not be able to create schedulings" do
        should_not be_able_to(:create, Factory.build(:post, blog: another_blog, author: another_employee))
      end

      it "should not be able to destroy schedulings" do
        should_not be_able_to(:destroy, Factory(:post, blog: another_blog, author: another_employee))
      end
    end
  end

  context "As an user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it "should not be able to read posts" do
      should_not be_able_to(:read, Factory(:post, blog: blog, author: some_employee))
    end

    it "should not be able to update posts" do
      should_not be_able_to(:update, Factory(:post, blog: blog, author: some_employee))
    end

    it "should not be able to create schedulings" do
      should_not be_able_to(:create, Factory.build(:post, blog: blog, author: some_employee))
    end

    it "should not be able to destroy schedulings" do
      should_not be_able_to(:destroy, Factory(:post, blog: blog, author: some_employee))
    end
  end
end