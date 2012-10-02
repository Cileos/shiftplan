require 'spec_helper'

describe SchedulingNotificationMailer do
  def comment(commentable, author, body, attrs={})
    Comment.build_from(commentable, author, attrs.reverse_merge(body: body)).tap(&:save!)
  end

  def clear_mails
    ActionMailer::Base.deliveries.clear
  end

  let(:account) { create :account }
  let(:organization) { create :organization, account: account }

  before :each do
    @user_owner =                       create :user, email: 'owner@shiftplan.local'
    @user_owner_2 =                     create :user, email: 'owner_2@shiftplan.local'
    @user_planner =                     create :user, email: 'planner@shiftplan.local'
    @user_employee_homer =              create :user, email: 'homer.simpson@shiftplan.local'
    @user_employee_bart =               create :user, email: 'bart.simpson@shiftplan.local'

    @employee_owner =                   create :employee_owner, account: account, user: @user_owner, first_name: 'Owner'
    @employee_owner_2 =                 create :employee_owner, account: account, user: @user_owner_2, first_name: 'Owner 2'
    @employee_planner =                 create :employee_planner, account: account, user: @user_planner, first_name: 'Planner'
    @employee_homer =                   create :employee, account: account, user: @user_employee_homer, first_name: 'Homer'
    @employee_bart =                    create :employee, account: account, user: @user_employee_bart, first_name: 'Bart'
    @employee_lisa_without_user =       create :employee, account: account, first_name: 'Lisa'

    [@employee_homer, @employee_bart, @employee_lisa_without_user].each do |employee|
      create :membership, employee: employee, organization: organization
    end

    @plan =                             create :plan, organization: organization, name: 'AKW Springfield'
    @scheduling_for_homer =             create :scheduling, quickie: '3-5 Reaktor putzen', starts_at: DateTime.parse('2012-12-21'),
                                          employee: @employee_homer, plan: @plan
    @scheduling_for_lisa_without_user = create :scheduling, quickie: '3-5 Reaktor putzen', starts_at: DateTime.parse('2012-12-21'),
                                          employee: @employee_lisa_without_user, plan: @plan
    clear_mails
  end

  it 'should set sender address no-reply@shiftplan.de' do
    comment(@scheduling_for_homer, @employee_owner, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')

    mail = SchedulingNotificationMailer.new_comment(Notification::Base.last)
    mail.from.should == ['no-reply@shiftplan.de']
  end

  shared_examples 'notifying planner, scheduled employee and other owners' do
    let(:unpersonalized_subject) { "Owner Simpson hat eine Schicht kommentiert" }
    it "should notify planner" do
      @employee_planner.should have_been_notified
        .with_subject(unpersonalized_subject)
        .with_body(unpersonalized_body)
    end

    it "should not notify the authoring owner" do
      @employee_owner.should_not have_been_notified
    end

    it "should notify the other owner" do
      @employee_owner_2.should have_been_notified
        .with_subject(unpersonalized_subject)
        .with_body(unpersonalized_body)
    end

    it "should notify the employee of the scheduling" do
      @employee_homer.should have_been_notified
        .with_subject("Owner Simpson hat eine Ihrer Schichten kommentiert")
        .with_body(personalized_body)
    end
  end


  describe "new comment by account owner" do
    before :each do
      comment(@scheduling_for_homer, @employee_owner, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
    end

    it_should_behave_like 'notifying planner, scheduled employee and other owners'
  end

  describe "second comment by account owner" do
    before :each do
      comment(@scheduling_for_homer, @employee_bart, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
      ActionMailer::Base.deliveries.clear

      # then owner comments on homers scheduling
      comment(@scheduling_for_homer, @employee_owner, 'Homer, denk bitte daran, bei Feierabend die Fenster zu schliessen')
    end
    let(:unpersonalized_body) { "Owner Simpson hat eine Schicht von Homer Simpson am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) kommentiert, die Sie auch kommentiert haben:" }
    let(:personalized_body)   { "Owner Simpson hat eine Ihrer Schichten am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) kommentiert:" }

    it_should_behave_like 'notifying planner, scheduled employee and other owners'

    it "should notify the employee who wrote the first comment" do
      @employee_bart.should have_been_notified
        .with_subject("Owner Simpson hat eine Schicht kommentiert, die Sie auch kommentiert haben")
        .with_body(personalized_body)
    end
  end

  describe "owner answers a question by the scheduled employee" do
    before :each do
      # bart comments on homers scheduling
      comment(@scheduling_for_homer, @employee_bart, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')

      # homer comments on own scheduling
      homers_comment = comment(@scheduling_for_homer, @employee_homer, 'Owner, bitte stell mir den Besen in die Putzkammer')

      clear_mails
      # owner answers homer's comment
      comment(@scheduling_for_homer, @employee_owner, 'Homer, denk bitte daran, bei Feierabend die Fenster zu schliessen', parent: homers_comment)
    end
    let(:unpersonalized_body) { "Owner Simpson hat auf einen Kommentar zu einer Schicht von Homer Simpson am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) geantwortet:" }
    let(:personalized_body)   { "Owner Simpson hat auf Ihren Kommentar zu einer Ihrer Schichten am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) geantwortet:" }

    it "should notify other commenters" do
      @employee_bart.should have_been_notified
        .with_subject("Owner Simpson hat auf einen Kommentar zu einer Schicht geantwortet, die Sie auch kommentiert haben")
        .with_body(unpersonalized_body)
    end

    it "should notify and address scheduled employee" do
      @employee_homer.should have_been_notified
        .with_subject("Owner Simpson hat auf Ihren Kommentar zu einer Ihrer Schichten geantwortet")
        .with_body(personalized_body)
    end
  end

  describe "owner answers a question by a bystanding employee" do
    before :each do
      barts_comment = comment(@scheduling_for_homer, @employee_bart, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
      clear_mails
      comment(@scheduling_for_homer, @employee_owner, 'Homer, denk bitte daran, bei Feierabend die Fenster zu schliessen', parent: barts_comment)
    end
    let(:unpersonalized_subject) { "Owner Simpson hat auf einen Kommentar zu einer Schicht geantwortet" }
    let(:unpersonalized_body) { "Owner Simpson hat auf einen Kommentar zu einer Schicht von Homer Simpson am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) geantwortet:" }
    let(:personalized_body)   { "Owner Simpson hat auf einen Kommentar zu einer Ihrer Schichten am Freitag, den 21.12.2012 (3-5 Reaktor putzen [Rp]) geantwortet:" }

    it "should notify the bystanding employee" do
      @employee_bart.should have_been_notified
        .with_subject("Owner Simpson hat auf Ihren Kommentar zu einer Schicht geantwortet")
        .with_body(unpersonalized_body.sub('einen Kommentar', 'Ihren Kommentar'))
    end

    it "should notify scheduled employee" do
      @employee_homer.should have_been_notified
        .with_subject("Owner Simpson hat auf einen Kommentar zu einer Ihrer Schichten geantwortet")
        .with_body(personalized_body)
    end

    it "should notify planner" do
      @employee_planner.should have_been_notified
        .with_subject(unpersonalized_subject)
        .with_body(unpersonalized_body)
    end

    it "should not notify owner himself" do
      @employee_owner.should_not have_been_notified
    end

    it "should notify other owner" do
      @employee_owner_2.should have_been_notified
        .with_subject(unpersonalized_subject)
        .with_body(unpersonalized_body)
    end

  end

  describe 'owner comments scheduling by employee without an email address' do
    it "should notify only other owner and planner" do
     # FIXME brittle
      expect {
        comment(@scheduling_for_lisa_without_user, @employee_owner, 'Homer, denk bitte daran, bei Feierabend den Reaktor zu putzen')
      }.to change(ActionMailer::Base.deliveries, :count).by(2)
    end
  end
end
