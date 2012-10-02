require 'spec_helper'

describe SchedulingNotificationMailer do
  def comment(commentable, author, body, attrs={})
    Comment.build_from(commentable, author, attrs.reverse_merge(body: body)).tap(&:save!)
  end

  describe 'new_comment' do

    before :each do
      @organization =                     create :organization

      @user_owner =                       create :user, email: 'owner@shiftplan.local'
      @user_owner_2 =                     create :user, email: 'owner_2@shiftplan.local'
      @user_planner =                     create :user, email: 'planner@shiftplan.local'
      @user_employee_homer =              create :user, email: 'homer.simpson@shiftplan.local'
      @user_employee_bart =               create :user, email: 'bart.simpson@shiftplan.local'

      @employee_owner =                   create :employee_owner, organizations: [@organization], user: @user_owner, first_name: 'Owner'
      @employee_owner_2 =                 create :employee_owner, organizations: [@organization], user: @user_owner_2, first_name: 'Owner 2'
      @employee_planner =                 create :employee_planner, organizations: [@organization], user: @user_planner, first_name: 'Planner'
      @employee_homer =                   create :employee, organizations: [@organization], user: @user_employee_homer, first_name: 'Homer'
      @employee_bart =                    create :employee, organizations: [@organization], user: @user_employee_bart, first_name: 'Bart'
      @employee_lisa_without_user =       create :employee, organizations: [@organization], first_name: 'Lisa'

      @plan =                             create :plan, organization: @organization, name: 'AKW Springfield'
      @scheduling_for_homer =             create :scheduling, quickie: '3-5 Reaktor putzen', starts_at: DateTime.parse('2012-12-21'),
                                            employee: @employee_homer, plan: @plan
      @scheduling_for_lisa_without_user = create :scheduling, quickie: '3-5 Reaktor putzen', starts_at: DateTime.parse('2012-12-21'),
                                            employee: @employee_lisa_without_user, plan: @plan

      ActionMailer::Base.deliveries.clear
    end

    it 'should have sender address no-reply@shiftplan.de' do
      comment(@scheduling_for_homer, @employee_owner, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')

      mail = SchedulingNotificationMailer.new_comment(Notification::Base.last)
      mail.from.should == ['no-reply@shiftplan.de']
    end

    describe 'recipients' do

      it 'should sent a mail to all planners, owners and employee of scheduling but not to the commenter itself' do
        expect {
          comment(@scheduling_for_homer, @employee_owner, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
        }.to change(ActionMailer::Base.deliveries, :count).by(3)

        'homer.simpson@shiftplan.local'.should have_received_mails(1)
        'planner@shiftplan.local'.should have_received_mails(1)
        'owner_2@shiftplan.local'.should have_received_mails(1)

        # owner is the commenter, so the owner does not receive a mail
        'owner@shiftplan.local'.should have_received_no_mail
      end

      it 'besides planners, owners and employee of scheduling also employees who commented before should be notified' do
        # employee bart comments on homers scheduling
        comment(@scheduling_for_homer, @employee_bart, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')

        ActionMailer::Base.deliveries.clear

        expect {
          # then owner comments on homers scheduling
          comment(@scheduling_for_homer, @employee_owner, 'Homer, denk bitte daran, bei Feierabend die Fenster zu schliessen')
        }.to change(ActionMailer::Base.deliveries, :count).by(4)

        'bart.simpson@shiftplan.local'.should have_received_mails(1)
        'homer.simpson@shiftplan.local'.should have_received_mails(1)
        'planner@shiftplan.local'.should have_received_mails(1)
        'owner_2@shiftplan.local'.should have_received_mails(1)

        # owner is the commenter, so the owner does not receive a mail
        'owner@shiftplan.local'.should have_received_no_mail
      end

      it 'should not try to send a notification to the employee of the scheduling if she has no user/email' do
        expect {
          comment(@scheduling_for_lisa_without_user, @employee_owner, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
        }.to change(ActionMailer::Base.deliveries, :count).by(2)
      end

    end

    describe 'subject' do

      it 'should have appropriate subjects' do
        comment(@scheduling_for_homer, @employee_bart, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')

        expect {
          comment(@scheduling_for_homer, @employee_owner, 'Homer, denk bitte daran, bei Feierabend die Fenster zu schliessen')
        }.to change(ActionMailer::Base.deliveries, :count).by(4)

        # as bart commented before, he receives a notification
        'bart.simpson@shiftplan.local'.should have_received_mails(1).with_subject("Owner Simpson hat eine Schicht kommentiert, die Sie auch kommentiert haben")

        # it's homer's scheduling that was commented
        'homer.simpson@shiftplan.local'.should have_received_mails(1).with_subject("Owner Simpson hat eine Ihrer Schichten kommentiert")

        'planner@shiftplan.local'.should have_received_mails(1).with_subject("Owner Simpson hat eine Schicht kommentiert")

        'owner_2@shiftplan.local'.should have_received_mails(1).with_subject("Owner Simpson hat eine Schicht kommentiert")
      end

      it 'should always make clear that it is my scheduling that was commented or that I have commented before' do
        # bart comments on homers scheduling
        comment(@scheduling_for_homer, @employee_bart, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')

        # homer comments on own scheduling
        comment(@scheduling_for_homer, @employee_homer, 'Owner, bitte stell mir den Besen in die Putzkammer')

        # owner comments on homers scheduling
        comment(@scheduling_for_homer, @employee_owner, 'Homer, denk bitte daran, bei Feierabend die Fenster zu schliessen')

        # as bart commented before, he receives a notification
        'bart.simpson@shiftplan.local'.should have_received_mails(1).with_subject("Owner Simpson hat eine Schicht kommentiert, die Sie auch kommentiert haben")

        # it's homer's scheduling that was commented
        'homer.simpson@shiftplan.local'.should have_received_mails(1).with_subject("Owner Simpson hat eine Ihrer Schichten kommentiert")
      end

      it 'should always make clear that it is my scheduling for which a comment was anwered or that I have commented before' do
        # bart comments on homers scheduling
        comment(@scheduling_for_homer, @employee_bart, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')

        # homer comments on own scheduling
        homers_comment = comment(@scheduling_for_homer, @employee_homer, 'Owner, bitte stell mir den Besen in die Putzkammer')

        # owner answers homer's comment
        comment(@scheduling_for_homer, @employee_owner, 'Homer, denk bitte daran, bei Feierabend die Fenster zu schliessen', parent: homers_comment)

        # as bart commented before, he receives a notification
        'bart.simpson@shiftplan.local'.should have_received_mails(1).with_subject("Owner Simpson hat auf einen Kommentar zu einer Schicht geantwortet, die Sie auch kommentiert haben")

        # it's homer's scheduling that was commented
        'homer.simpson@shiftplan.local'.should have_received_mails(1).with_subject("Owner Simpson hat auf Ihren Kommentar zu einer Ihrer Schichten geantwortet")
      end

      it 'should have appropriate subjects for answers on comments' do
        barts_comment = comment(@scheduling_for_homer, @employee_bart, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')

        expect {
          comment(@scheduling_for_homer, @employee_owner, 'Homer, denk bitte daran, bei Feierabend die Fenster zu schliessen', parent: barts_comment)
        }.to change(ActionMailer::Base.deliveries, :count).by(4)

        # as bart commented before, he receives a notification
        'bart.simpson@shiftplan.local'.should have_received_mails(1).with_subject("Owner Simpson hat auf Ihren Kommentar zu einer Schicht geantwortet")

        # it's homer's scheduling that was commented
        'homer.simpson@shiftplan.local'.should have_received_mails(1).with_subject("Owner Simpson hat auf einen Kommentar zu einer Ihrer Schichten geantwortet")

        'planner@shiftplan.local'.should have_received_mails(1).with_subject("Owner Simpson hat auf einen Kommentar zu einer Schicht geantwortet")

        'owner_2@shiftplan.local'.should have_received_mails(1).with_subject("Owner Simpson hat auf einen Kommentar zu einer Schicht geantwortet")
      end

    end

    describe 'body' do

      context "for the second comment on scheduling" do
        before :each do
          comment(@scheduling_for_homer, @employee_bart, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
        end
        let(:unpersonalized_body) { "Owner Simpson hat eine Schicht von Homer Simpson am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) kommentiert, die Sie auch kommentiert haben:" }
        let(:personalized_body)   { "Owner Simpson hat eine Ihrer Schichten am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) kommentiert:" }

        it "should notify author of first comment" do
          @employee_bart.should have_been_notified.with_body(unpersonalized_body)
        end

        it "should notify author of scheduling" do
          @employee_homer.should have_been_notified.with_body(personalized_body)
        end

        it "should notify planner" do
          @user_planner.should have_been_notified.with_body(unpersonalized_body)
        end

        it "should notify owner" do
          @employee_owner_2.should have_been_notified.with_body(unpersonalized_body)
        end

      end

      describe "for the answer to a comment on a scheduling" do
        before :each do
          comment(@scheduling_for_homer, @employee_bart, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
        end
        let(:unpersonalized_body) { "Owner Simpson hat auf einen Kommentar zu einer Schicht von Homer Simpson am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) geantwortet:" }
        let(:personalized_body)   { "Owner Simpson hat auf einen Kommentar zu einer Ihrer Schichten am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) geantwortet:" }

        it "should notify author of first comment" do
          @employee_bart.should have_been_notified.with_body(unpersonalized_body.sub('einen Kommentar', 'Ihren Kommentar'))
        end

        it "should notify author of scheduling" do
          @employee_homer.should have_been_notified.with_body(personalized_body)
        end

        it "should notify planner" do
          @user_planner.should have_been_notified.with_body(unpersonalized_body)
        end

        it "should notify owner" do
          @employee_owner_2.should have_been_notified.with_body(unpersonalized_body)
        end
      end

      it 'should always should make clear that it is my own scheduling or that I commented before' do
        comment(@scheduling_for_homer, @employee_bart, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')

        # homer comments his own shift
        homers_comment = comment(@scheduling_for_homer, @employee_homer, 'Owner Simpson, bitte stell mir den Besen in die Putzkammer')

        # owner writes answer for homers comment
        comment(@scheduling_for_homer, @employee_owner, 'Homer, habe ich gerade erledigt.', parent: homers_comment)

        # as bart commented before, he receives a notification
        'bart.simpson@shiftplan.local'.should have_received_mails(1).with_body("Owner Simpson hat auf einen Kommentar zu einer Schicht von Homer Simpson am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) geantwortet. Diese Schicht haben Sie ebenfalls kommentiert:")

        # it's homer's scheduling that was commented
        'homer.simpson@shiftplan.local'.should have_received_mails(1).with_body("Owner Simpson hat auf Ihren Kommentar zu einer Ihrer Schichten am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) geantwortet:")
      end
    end

  end
end

