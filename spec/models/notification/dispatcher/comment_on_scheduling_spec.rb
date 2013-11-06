describe Notification::Dispatcher::CommentOnScheduling do

  shared_examples :not_creating_a_comment_on_scheduling_notification_for_the_employee do
    it "does not create a notification" do
      notifications.should be_empty
    end
  end

  shared_examples :creating_a_comment_on_scheduling_notification_for_the_employee do
    it "creates a notification" do
      notifications.should_not be_empty
    end
  end

  let(:dispatcher)          { described_class.new(origin) }
  let(:notification_class)  { Notification::CommentOnScheduling }

  let(:origin) do
    Comment.build_from(scheduling, author, body: 'some text').tap(&:save!)
  end

  let(:author) do
    create(:employee_with_confirmed_user, account: account).tap do |e|
      create(:membership, organization: organization, employee: e)
    end
  end

  let(:commenter) do
    create(:employee_with_confirmed_user, account: account).tap do |e|
      create(:membership, organization: organization, employee: e)
    end
  end

  let(:scheduling) do
    create(:scheduling, employee: scheduled_employee, plan: plan)
  end

  let(:plan)                { create(:plan, organization: organization) }
  let(:organization)        { create(:organization, account: account) }
  let(:account)             { create(:account) }

  let(:other_organization)  { create(:organization) }

  let(:scheduled_employee) do
    create(:employee_with_confirmed_user, account: account).tap do |e|
      create(:membership, organization: organization, employee: e)
    end
  end

  let(:planner) do
    create(:employee_with_confirmed_user, account: account).tap do |e|
      create(:membership, organization: organization, employee: e, role: 'planner')
    end
  end

  let(:planner_without_user) do
    create(:employee, account: account).tap do |e|
      create(:membership, organization: organization, employee: e, role: 'planner')
    end
  end

  let(:planner_with_unconfirmed_user) do
    create(:employee_with_unconfirmed_user, account: account).tap do |e|
      create(:membership, organization: organization, employee: e, role: 'planner')
    end
  end

  let(:owner) do
    create(:employee_owner, account: account, user: create(:confirmed_user))
  end

  let(:another_comment) { nil } # no other comment needed for most examples

  it "creates the expected total number of notifications" do
    author
    scheduled_employee
    owner
    planner
    commenter
    Comment.build_from(scheduling, commenter, body: 'some text').tap(&:save!)
    planner_without_user
    planner_with_unconfirmed_user

    expect do
      dispatcher.create_notifications!
    end.to change(Notification::CommentOnScheduling, :count).from(0).to(4)
  end

  context "#create_notifications!" do

    before(:each) do
      the_employee # to create record beforehand
      another_comment
      dispatcher.create_notifications!
    end

    let(:notifications) do
      notification_class.where(employee_id: the_employee.id,
        notifiable_id: origin.id, notifiable_type: 'Comment')
    end

    context "for the author of the comment" do
      let(:the_employee) { author }
      it_behaves_like :not_creating_a_comment_on_scheduling_notification_for_the_employee
    end

    context "for the scheduled employee" do
      let(:the_employee) { scheduled_employee }
      let(:notification_class)  { Notification::CommentOnSchedulingOfEmployee }

      it_behaves_like :creating_a_comment_on_scheduling_notification_for_the_employee
    end

    context "for the account owner" do
      let(:the_employee) { owner }
      it_behaves_like :creating_a_comment_on_scheduling_notification_for_the_employee
    end

    context "for the planner" do
      let(:the_employee) { planner }
      it_behaves_like :creating_a_comment_on_scheduling_notification_for_the_employee
    end

    context "for the commenter" do
      let(:the_employee) { commenter }
      let(:notification_class)  { Notification::CommentOnSchedulingForCommenter }
      let(:another_comment) do
        Comment.build_from(scheduling, the_employee, body: 'some text').tap(&:save!)
      end

      it_behaves_like :creating_a_comment_on_scheduling_notification_for_the_employee
    end

    context "for planner without user" do
      let(:the_employee) { planner_without_user }
      it_behaves_like :not_creating_a_comment_on_scheduling_notification_for_the_employee
    end

    context "for planner with an unconfirmed user" do
      let(:the_employee) { planner_with_unconfirmed_user }
      it_behaves_like :not_creating_a_comment_on_scheduling_notification_for_the_employee
    end
  end

  context "#recipients" do
    it "does not return duplicates" do
      org = instance_double('Organization')
      dispatcher.stub(:organization).and_return(org)
      org.stub(planners: [planner, planner], owner: nil)
      dispatcher.send(:recipients).should == [planner, scheduled_employee]
    end
  end
end
