require 'spec_helper'
require "cancan/matchers"

describe "Comment permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }

  let(:account) { create(:account)}
  let(:organization) { create(:organization, account: account) }
  let(:some_employee) { create(:employee, account: account) }
  let(:membership) { create(:membership, employee: some_employee, organization: organization) }

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
    membership
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "As an owner" do
    let(:employee) { create(:employee_owner, account: account, user: user) }

    context "for own accounts" do
      # reading
      it "I should be able to read comments on posts" do
        comment = Comment.build_from(post, some_employee, body: 'some text')
        should be_able_to(:read, comment)
      end
      it "I should be able to read comments on schedulings" do
        comment = Comment.build_from(scheduling, some_employee, body: 'some text')
        should be_able_to(:read, comment)
      end

      # creating
      it "I should be able to create comments on posts" do
        comment = Comment.build_from(post, employee, body: 'some text')
        should be_able_to(:create, comment)
      end
      it "I should be able to create comments on schedulings" do
        comment = Comment.build_from(scheduling, employee, body: 'some text')
        should be_able_to(:create, comment)
      end

      # destroying
      it "I should be able to destroy my own comments on posts" do
        comment = Comment.build_from(post, employee, body: 'some text')
        should be_able_to(:destroy, comment)
      end
      it "I should be able to destroy my own comments on schedulings" do
        comment = Comment.build_from(scheduling, employee, body: 'some text')
        should be_able_to(:destroy, comment)
      end
      it "I should not be able to destroy comments on posts having an author different than me" do
        comment = Comment.build_from(post, some_employee, body: 'some text')
        should_not be_able_to(:destroy, comment)
      end
      it "I should not be able to destroy comments on schedulings having an author different than me" do
        comment = Comment.build_from(scheduling, some_employee, body: 'some text')
        should_not be_able_to(:destroy, comment)
      end

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

    context "for other accounts" do
      # reading
      it "I should not be able to read comments on posts" do
        comment = Comment.build_from(other_post, other_employee, body: 'some text')
        should_not be_able_to(:read, comment)
      end

      it "I should not be able to read comments on schedulings" do
        comment = Comment.build_from(other_scheduling, other_employee, body: 'some text')
        should_not be_able_to(:read, comment)
      end

      # creating
      it "I should not be able to create comments on posts of different accounts" do
        comment = Comment.build_from(other_post, employee, body: 'some text')
        should_not be_able_to(:create, comment)
      end
      it "I should not be able to create comments on schedulings of different accounts" do
        comment = Comment.build_from(other_scheduling, employee, body: 'some text')
        should_not be_able_to(:create, comment)
      end
    end
  end

  # context "As a planner" do
  #   let(:employee) { create(:employee, organization: organization, user: user) }

  #   context "for my own organization" do
  #     it "I should not be able to destroy comments having an author different than me" do
  #       comment = Comment.build_from(post, some_employee, body: 'some text')
  #       should_not be_able_to(:destroy, comment)
  #     end

  #     it "should not be able to update comments" do
  #       comment = Comment.build_from(post, employee, body: 'some text')
  #       should_not be_able_to(:update, comment)
  #     end
  #   end

  #   context "for other organizations" do

  #     let(:comment) { comment = Comment.build_from(another_post, other_employee, body: 'some text') }

  #     it "should not be able to create comments" do
  #       should_not be_able_to(:create, comment)
  #     end

  #     it "should not be able to read comments" do
  #       should_not be_able_to(:read, comment)
  #     end

  #     it "should not be able to destroy comments" do
  #       should_not be_able_to(:destroy, comment)
  #     end

  #     it "should not be able to update comments" do
  #       should_not be_able_to(:update, comment)
  #     end
  #   end
  # end

  # context "As an employee" do
  #   let(:employee) { create(:employee, organization: organization, user: user) }

  #   context "for my own organization" do
  #     it "I should not be able to destroy comments having an author different than me" do
  #       comment = Comment.build_from(post, some_employee, body: 'some text')
  #       should_not be_able_to(:destroy, comment)
  #     end

  #     it "should not be able to update comments" do
  #       comment = Comment.build_from(post, employee, body: 'some text')
  #       should_not be_able_to(:update, comment)
  #     end
  #   end

  #   context "for other organizations" do

  #     let(:comment) { comment = Comment.build_from(another_post, other_employee, body: 'some text') }

  #     it "should not be able to create comments" do
  #       should_not be_able_to(:create, comment)
  #     end

  #     it "should not be able to read comments" do
  #       should_not be_able_to(:read, comment)
  #     end

  #     it "should not be able to destroy comments" do
  #       should_not be_able_to(:destroy, comment)
  #     end

  #     it "should not be able to update comments" do
  #       should_not be_able_to(:update, comment)
  #     end
  #   end
  # end
end
