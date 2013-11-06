describe Notification::Dispatcher::Post do
  shared_examples :not_creating_a_post_notification_for_the_employee do
    it "does not create a notification" do
      dispatcher.create_notifications!

      notifications.should be_empty
    end
  end

  let(:origin)              { create(:post, blog: blog, author: author) }
  let(:blog)                { create(:blog, organization: organization) }
  let(:dispatcher)          { described_class.new(origin) }

  let(:organization)        { create(:organization, account: account) }
  let(:other_organization)  { create(:organization, account: account) }
  let(:account)             { create(:account) }

  let(:author) do
    create(:employee_with_confirmed_user, account: account).tap do |e|
      create(:membership, organization: organization, employee: e)
    end
  end

  # coworker is a member of the organization of the post
  let(:coworker) do
    create(:employee_with_confirmed_user, account: account).tap do |e|
      create(:membership, organization: organization, employee: e)
    end
  end
  let(:unconfirmed_coworker) do
    create(:employee_with_unconfirmed_user, account: account).tap do |e|
      create(:membership, organization: organization, employee: e)
    end
  end
  let(:coworker_without_user) do
    create(:employee, account: account).tap do |e|
      create(:membership, organization: organization, employee: e)
    end
  end

  let(:other_employee) do
    create(:employee_with_confirmed_user, account: account).tap do |e|
      create(:membership, organization: other_organization, employee: e)
    end
  end

  context "#create_notifications!" do

    let(:notifications) do
      Notification::Post.where(employee_id: the_employee.id,
        notifiable_id: origin.id, notifiable_type: 'Post')
    end

    it "creates the expected total number of notifications" do
      coworker
      author
      unconfirmed_coworker
      coworker_without_user
      other_employee

      expect do
        dispatcher.create_notifications!
      end.to change(Notification::Post, :count).from(0).to(1)
    end

    context "for a confirmed coworker" do
      let!(:the_employee) { coworker }

      it "creates a notification" do
        dispatcher.create_notifications!

        notifications.should_not be_empty
      end
    end

    context "for the author of the post" do
      let!(:the_employee) { author }
      it_behaves_like :not_creating_a_post_notification_for_the_employee
    end

    context "for an unconfirmed coworker" do
      let!(:the_employee) { unconfirmed_coworker }
      it_behaves_like :not_creating_a_post_notification_for_the_employee
    end

    context "for a coworker without a user" do
      let!(:the_employee) { coworker_without_user }
      it_behaves_like :not_creating_a_post_notification_for_the_employee
    end

    context "for an employee of a different organization" do
      let!(:the_employee) { other_employee }
      it_behaves_like :not_creating_a_post_notification_for_the_employee
    end
  end
end
