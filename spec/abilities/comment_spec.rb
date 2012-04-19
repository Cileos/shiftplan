require 'spec_helper'
require "cancan/matchers"

describe "Scheduling permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { Factory(:user) }
  let(:organization) { Factory(:organization) }
  let(:blog) { Factory(:blog, organization: organization) }
  let(:post) { Factory(:post, blog: blog) }
  let(:some_employee) { Factory(:employee, organization: organization) }

  let(:another_organization) { Factory(:organization) }
  let(:another_blog) { Factory(:blog, organization: another_organization) }
  let(:another_post) { Factory(:post, blog: another_blog) }
  let(:other_employee) { Factory(:employee, organization: another_organization) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "As an owner" do
    let(:employee) { Factory(:owner, organization: organization, user: user) }

    context "for my own organization" do
      it "I should not be able to destroy comments having an author different than me" do
        comment = Comment.build_from(post, some_employee, body: 'some text')
        should_not be_able_to(:destroy, comment)
      end

      it "should not be able to update comments" do
        comment = Comment.build_from(post, employee, body: 'some text')
        should_not be_able_to(:update, comment)
      end
    end

    context "for other organizations" do

      let(:comment) { comment = Comment.build_from(another_post, other_employee, body: 'some text') }

      it "should not be able to create comments" do
        should_not be_able_to(:create, comment)
      end

      it "should not be able to read comments" do
        should_not be_able_to(:read, comment)
      end

      it "should not be able to destroy comments" do
        should_not be_able_to(:destroy, comment)
      end

      it "should not be able to update comments" do
        should_not be_able_to(:update, comment)
      end
    end
  end

  context "As a planner" do
    let(:employee) { Factory(:employee, organization: organization, user: user) }

    context "for my own organization" do
      it "I should not be able to destroy comments having an author different than me" do
        comment = Comment.build_from(post, some_employee, body: 'some text')
        should_not be_able_to(:destroy, comment)
      end

      it "should not be able to update comments" do
        comment = Comment.build_from(post, employee, body: 'some text')
        should_not be_able_to(:update, comment)
      end
    end

    context "for other organizations" do

      let(:comment) { comment = Comment.build_from(another_post, other_employee, body: 'some text') }

      it "should not be able to create comments" do
        should_not be_able_to(:create, comment)
      end

      it "should not be able to read comments" do
        should_not be_able_to(:read, comment)
      end

      it "should not be able to destroy comments" do
        should_not be_able_to(:destroy, comment)
      end

      it "should not be able to update comments" do
        should_not be_able_to(:update, comment)
      end
    end
  end

  context "As an employee" do
    let(:employee) { Factory(:employee, organization: organization, user: user) }

    context "for my own organization" do
      it "I should not be able to destroy comments having an author different than me" do
        comment = Comment.build_from(post, some_employee, body: 'some text')
        should_not be_able_to(:destroy, comment)
      end

      it "should not be able to update comments" do
        comment = Comment.build_from(post, employee, body: 'some text')
        should_not be_able_to(:update, comment)
      end
    end

    context "for other organizations" do

      let(:comment) { comment = Comment.build_from(another_post, other_employee, body: 'some text') }

      it "should not be able to create comments" do
        should_not be_able_to(:create, comment)
      end

      it "should not be able to read comments" do
        should_not be_able_to(:read, comment)
      end

      it "should not be able to destroy comments" do
        should_not be_able_to(:destroy, comment)
      end

      it "should not be able to update comments" do
        should_not be_able_to(:update, comment)
      end
    end
  end
end
