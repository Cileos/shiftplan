require 'spec_helper'

describe SchedulingNotificationMailer do

  describe 'new_comment' do

    before :each do
      @organization =                     create :organization

      @user_owner =                       create :user, email: 'owner@shiftplan.local'
      @user_owner_2 =                     create :user, email: 'owner_2@shiftplan.local'
      @user_planner =                     create :user, email: 'planner@shiftplan.local'
      @user_employee_homer =              create :user, email: 'homer.simpson@shiftplan.local'
      @user_employee_bart =               create :user, email: 'bart.simpson@shiftplan.local'

      @employee_owner =                   create :employee_owner, organization: @organization, user: @user_owner, first_name: 'Owner'
      @employee_owner_2 =                 create :employee_owner, organization: @organization, user: @user_owner_2, first_name: 'Owner 2'
      @employee_planner =                 create :employee_planner, organization: @organization, user: @user_planner, first_name: 'Planner'
      @employee_homer =                   create :employee, organization: @organization, user: @user_employee_homer, first_name: 'Homer'
      @employee_bart =                    create :employee, organization: @organization, user: @user_employee_bart, first_name: 'Bart'
      @employee_lisa_without_user =       create :employee, organization: @organization, first_name: 'Lisa'

      @plan =                             create :plan, organization: @organization, name: 'AKW Springfield'
      @scheduling_for_homer =             create :scheduling, quickie: '3-5 Reaktor putzen', starts_at: DateTime.parse('2012-12-21'),
                                            employee: @employee_homer, plan: @plan
      @scheduling_for_lisa_without_user = create :scheduling, quickie: '3-5 Reaktor putzen', starts_at: DateTime.parse('2012-12-21'),
                                            employee: @employee_lisa_without_user, plan: @plan

      ActionMailer::Base.deliveries = []
    end

    it 'should have sender address no-reply@shiftplan.de' do
      owners_comment = Comment.build_from(@scheduling_for_homer, @employee_owner,
        body: 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
      owners_comment.save!

      mail = SchedulingNotificationMailer.new_comment(Notification::Base.last)
      mail.from.should == ['no-reply@shiftplan.de']
    end

    describe 'recipients' do

      it 'should sent a mail to all planners, owners and employee of scheduling but not to the commenter itself' do
        expect {
          owners_comment = Comment.build_from(@scheduling_for_homer, @employee_owner,
            body: 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
          owners_comment.save!
        }.to change(ActionMailer::Base.deliveries, :count).by(3)

        'homer.simpson@shiftplan.local'.should have_received_mails(1)
        'planner@shiftplan.local'.should have_received_mails(1)
        'owner_2@shiftplan.local'.should have_received_mails(1)

        # owner is the commenter, so the owner does not receive a mail
        'owner@shiftplan.local'.should have_received_no_mail
      end

      it 'besides planners, owners and employee of scheduling also employees who commented before should be notified' do
        # employee bart comments on homers scheduling
        barts_comment = Comment.build_from(@scheduling_for_homer, @employee_bart,
          body: 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
        barts_comment.save!

        ActionMailer::Base.deliveries = []

        expect {
          # then owner comments on homers scheduling
          owners_comment = Comment.build_from(@scheduling_for_homer, @employee_owner,
            body: 'Homer, denk bitte daran, bei Feierabend die Fenster zu schliessen')
          owners_comment.save!
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
          owners_comment = Comment.build_from(@scheduling_for_lisa_without_user, @employee_owner,
              body: 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
          owners_comment.save!
        }.to change(ActionMailer::Base.deliveries, :count).by(2)
      end

    end

    describe 'subject' do

      it 'should have appropriate subjects' do
        barts_comment = Comment.build_from(@scheduling_for_homer, @employee_bart,
          body: 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
        barts_comment.save!

        expect {
          owners_comment = Comment.build_from(@scheduling_for_homer, @employee_owner,
            body: 'Homer, denk bitte daran, bei Feierabend die Fenster zu schliessen')
          owners_comment.save!
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
        barts_comment = Comment.build_from(@scheduling_for_homer, @employee_bart,
          body: 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
        barts_comment.save!

        # homer comments on own scheduling
        homers_comment = Comment.build_from(@scheduling_for_homer, @employee_homer,
          body: 'Owner, bitte stell mir den Besen in die Putzkammer')
        homers_comment.save!

        # owner comments on homers scheduling
        owners_comment = Comment.build_from(@scheduling_for_homer, @employee_owner,
          body: 'Homer, denk bitte daran, bei Feierabend die Fenster zu schliessen')
        owners_comment.save!

        # as bart commented before, he receives a notification
        'bart.simpson@shiftplan.local'.should have_received_mails(1).with_subject("Owner Simpson hat eine Schicht kommentiert, die Sie auch kommentiert haben")

        # it's homer's scheduling that was commented
        'homer.simpson@shiftplan.local'.should have_received_mails(1).with_subject("Owner Simpson hat eine Ihrer Schichten kommentiert")
      end

      it 'should always make clear that it is my scheduling for which a comment was anwered or that I have commented before' do
        # bart comments on homers scheduling
        barts_comment = Comment.build_from(@scheduling_for_homer, @employee_bart,
          body: 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
        barts_comment.save!

        # homer comments on own scheduling
        homers_comment = Comment.build_from(@scheduling_for_homer, @employee_homer,
          body: 'Owner, bitte stell mir den Besen in die Putzkammer')
        homers_comment.save!

        # owner answers homer's comment
        owners_comment = Comment.build_from(@scheduling_for_homer, @employee_owner,
          body: 'Homer, denk bitte daran, bei Feierabend die Fenster zu schliessen',
          parent: homers_comment)
        owners_comment.save!

        # as bart commented before, he receives a notification
        'bart.simpson@shiftplan.local'.should have_received_mails(1).with_subject("Owner Simpson hat auf einen Kommentar zu einer Schicht geantwortet, die Sie auch kommentiert haben")

        # it's homer's scheduling that was commented
        'homer.simpson@shiftplan.local'.should have_received_mails(1).with_subject("Owner Simpson hat auf Ihren Kommentar zu einer Ihrer Schichten geantwortet")
      end

      it 'should have appropriate subjects for answers on comments' do
        barts_comment = Comment.build_from(@scheduling_for_homer, @employee_bart,
          body: 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
        barts_comment.save!

        expect {
          owners_comment = Comment.build_from(@scheduling_for_homer, @employee_owner,
            body: 'Homer, denk bitte daran, bei Feierabend die Fenster zu schliessen',
            parent: barts_comment)
          owners_comment.save!
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

      it 'should have appropriate information about the scheduling that was commented on in the email body' do
        barts_comment = Comment.build_from(@scheduling_for_homer, @employee_bart,
          body: 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
        barts_comment.save!

        expect {
          owners_comment = Comment.build_from(@scheduling_for_homer, @employee_owner,
            body: 'Homer, denk bitte daran, bei Feierabend die Fenster zu schliessen')
          owners_comment.save!
        }.to change(ActionMailer::Base.deliveries, :count).by(4)

        # as bart commented before, he receives a notification
        'bart.simpson@shiftplan.local'.should have_received_mails(1).with_body("Owner Simpson hat eine Schicht von Homer Simpson am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) kommentiert, die Sie auch kommentiert haben:")

        # it's homer's scheduling that was commented
        'homer.simpson@shiftplan.local'.should have_received_mails(1).with_body("Owner Simpson hat eine Ihrer Schichten am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) kommentiert:")

        'planner@shiftplan.local'.should have_received_mails(1).with_body("Owner Simpson hat eine Schicht von Homer Simpson am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) kommentiert:")

        'owner_2@shiftplan.local'.should have_received_mails(1).with_body("Owner Simpson hat eine Schicht von Homer Simpson am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) kommentiert:")
      end

      it 'should have appropriate information about the scheduling for which an answer on a comment was written in the email body' do
        barts_comment = Comment.build_from(@scheduling_for_homer, @employee_bart,
          body: 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
        barts_comment.save!

        expect {
          owners_comment = Comment.build_from(@scheduling_for_homer, @employee_owner,
            body: 'Homer, denk bitte daran, bei Feierabend die Fenster zu schliessen',
            parent: barts_comment)
          owners_comment.save!
        }.to change(ActionMailer::Base.deliveries, :count).by(4)

        # as bart commented before, he receives a notification
        'bart.simpson@shiftplan.local'.should have_received_mails(1).with_body("Owner Simpson hat auf Ihren Kommentar zu einer Schicht von Homer Simpson am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) geantwortet:")

        # it's homer's scheduling that was commented
        'homer.simpson@shiftplan.local'.should have_received_mails(1).with_body("Owner Simpson hat auf einen Kommentar zu einer Ihrer Schichten am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) geantwortet:")

        'planner@shiftplan.local'.should have_received_mails(1).with_body("Owner Simpson hat auf einen Kommentar zu einer Schicht von Homer Simpson am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) geantwortet:")

        'owner_2@shiftplan.local'.should have_received_mails(1).with_body("Owner Simpson hat auf einen Kommentar zu einer Schicht von Homer Simpson am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) geantwortet:")
      end

      it 'should always should make clear that it is my own scheduling or that I commented before' do
        barts_comment = Comment.build_from(@scheduling_for_homer, @employee_bart,
          body: 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
        barts_comment.save!

        # homer comments his own shift
        homers_comment = Comment.build_from(@scheduling_for_homer, @employee_homer,
          body: 'Owner Simpson, bitte stell mir den Besen in die Putzkammer')
        homers_comment.save!

        # owner writes answer for homers comment
        owners_comment = Comment.build_from(@scheduling_for_homer, @employee_owner,
          body: 'Homer, habe ich gerade erledigt.',
          parent: homers_comment)
        owners_comment.save!

        # as bart commented before, he receives a notification
        'bart.simpson@shiftplan.local'.should have_received_mails(1).with_body("Owner Simpson hat auf einen Kommentar zu einer Schicht von Homer Simpson am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) geantwortet. Diese Schicht haben Sie ebenfalls kommentiert:")

        # it's homer's scheduling that was commented
        'homer.simpson@shiftplan.local'.should have_received_mails(1).with_body("Owner Simpson hat auf Ihren Kommentar zu einer Ihrer Schichten am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) geantwortet:")
      end
    end

  end
end

