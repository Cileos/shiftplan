require 'spec_helper'

describe NestedResourceDispatcher do

  describe '#resources_for' do

    let(:account)       { stub_model Account }
    let(:organization)  { stub_model Organization, account: account }
    let(:blog)          { stub_model Blog, organization: organization }
    let(:team)          { stub_model Team, organization: organization }
    let(:plan)          { stub_model Plan, organization: organization }
    let(:plan_template) { stub_model PlanTemplate, organization: organization }
    let(:blog_post)     { stub_model Post, blog: blog }
    let(:shift)         { stub_model Shift, plan_template: plan_template }
    let(:scheduling)    { stub_model Scheduling, plan: plan }
    let(:attached_doc)  { stub_model AttachedDocument, plan: plan }



    describe 'for an Organization' do
      it 'is nested under its account' do
        subject.resources_for(organization).should == [account, organization]
      end

      # we cannot stub the case structure, so we take the Organization as an example
      it 'can add an extra' do
        subject.resources_for(organization, :edit).should == [account, organization, :edit]
      end
      it 'can add extras' do
        subject.resources_for(organization, :edit, :quickly).should == [account, organization, :edit, :quickly]
      end
    end

    shared_examples :nested_under_organization do
      it 'is nested under its organization' do
        subject.resources_for(record).should == [account, organization, record]
      end
    end

    describe 'for a Blog' do
      let(:record) { blog }
      it_should_behave_like :nested_under_organization
    end

    describe 'for a Team' do
      let(:record) { team }
      it_should_behave_like :nested_under_organization
    end

    describe 'for a Plan' do
      let(:record) { plan }
      it_should_behave_like :nested_under_organization
    end

    describe 'for a PlanTemplate' do
      let(:record) { plan_template }
      it_should_behave_like :nested_under_organization
    end


    describe 'for a Comment' do
      let(:comment)     { stub_model Comment, commentable: commentable }
      let(:commentable) { blog_post }
      it 'is nested under its blog and its commentable' do
        subject.resources_for(comment).should == [account, organization, blog, commentable, comment]
      end
    end

    describe 'for a Post' do
      it 'is nested under its blog' do
        subject.resources_for(blog_post).should == [account, organization, blog, blog_post]
      end
    end

    describe 'for a Shift' do
      it 'is nested under its plan_template' do
        subject.resources_for(shift).should == [account, organization, plan_template, shift]
      end
    end

    describe 'for a Scheduling' do
      it 'is nested under its plan' do
        subject.resources_for(scheduling).should == [account, organization, plan, scheduling]
      end
    end

    describe 'for a AttachedDocument' do
      it 'is nested under its plan' do
        subject.resources_for(attached_doc).should == [account, organization, plan, attached_doc]
      end
    end

  end

end
