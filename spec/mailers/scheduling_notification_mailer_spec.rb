require 'spec_helper'

describe SchedulingNotificationMailer do
  describe 'new_comment' do

    before :each do
      @organization =                     Factory :organization

      @user_owner =                       Factory :user, email: 'owner@shiftplan.local'
      @user_owner_2 =                     Factory :user, email: 'owner_2@shiftplan.local'
      @user_planner =                     Factory :user, email: 'planner@shiftplan.local'
      @user_employee_homer =              Factory :user, email: 'homer.simpson@shiftplan.local'
      @user_employee_bart =               Factory :user, email: 'bart.simpson@shiftplan.local'

      @employee_owner =                   Factory :employee_owner, organization: @organization, user: @user_owner, first_name: 'Owner'
      @employee_owner_2 =                 Factory :employee_owner, organization: @organization, user: @user_owner_2, first_name: 'Owner 2'
      @employee_planner =                 Factory :employee_planner, organization: @organization, user: @user_planner, first_name: 'Planner'
      @employee_homer =                   Factory :employee, organization: @organization, user: @user_employee_homer, first_name: 'Homer'
      @employee_bart =                    Factory :employee, organization: @organization, user: @user_employee_bart, first_name: 'Bart'
      @employee_lisa_without_user =       Factory :employee, organization: @organization, first_name: 'Lisa'

      @plan =                             Factory :plan, organization: @organization, name: 'AKW Springfield'
      @scheduling =                       Factory :scheduling, quickie: '3-5 Reaktor putzen', employee: @employee_homer, plan: @plan
      @scheduling_for_lisa_without_user = Factory :scheduling, quickie: '3-5 Reaktor putzen',
        employee: @employee_lisa_without_user, plan: @plan

      ActionMailer::Base.deliveries = []
    end

    it 'should sent a mail to all planners, owners and employee of scheduling but not to the commenter itself' do
      owners_comment = Comment.build_from(@scheduling, @employee_owner,
        body: 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen').save!

      ActionMailer::Base.deliveries.count.should == 3

      homers_mails = ActionMailer::Base.deliveries.select { |mail| mail.to == ['homer.simpson@shiftplan.local'] }
      homers_mails.count.should == 1

      planners_mails = ActionMailer::Base.deliveries.select { |mail| mail.to == ['planner@shiftplan.local'] }
      planners_mails.count.should == 1

      owner_2_mails = ActionMailer::Base.deliveries.select { |mail| mail.to == ['owner_2@shiftplan.local'] }
      owner_2_mails.count.should == 1

      # owner is the commenter, so the owner does not receive a mail
      owners_mails = ActionMailer::Base.deliveries.select { |mail| mail.to == ['owner@shiftplan.local'] }
      owners_mails.should be_empty
    end

    it 'should not try to send a notification to the employee of the scheduling if she has no user/email' do
      owners_comment = Comment.build_from(@scheduling_for_lisa_without_user, @employee_owner,
          body: 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen').save!

      ActionMailer::Base.deliveries.count.should == 2
    end
  end
end

