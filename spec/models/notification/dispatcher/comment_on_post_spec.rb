describe Notification::Dispatcher::CommentOnPost do
  shared_examples :not_creating_a_comment_on_post_notification_for_the_employee do
    it "does not create a notification" do
      dispatcher.create_notifications!

      notifications.should be_empty
    end
  end

  shared_examples :creating_a_comment_on_post_notification_for_the_employee do
    it "creates a notification" do
      dispatcher.create_notifications!

      notifications.should_not be_empty
    end
  end

  let(:dispatcher)          { described_class.new(origin) }
  let(:notification_class)  { Notification::CommentOnPost }

  let(:origin) do
    Comment.build_from(post, author, body: 'a comment').tap(&:save!)
  end

  let(:post)                { create(:post, blog: blog, author: post_author) }
  let(:blog)                { create(:blog, organization: organization) }

  let(:organization)        { create(:organization, account: account) }
  let(:other_organization)  { create(:organization, account: account) }
  let(:account)             { create(:account) }

  let(:author) do
    create(:employee_with_confirmed_user, account: account, first_name: 'Author').tap do |e|
      create(:membership, organization: organization, employee: e)
    end
  end

  let(:post_author) do
    create(:employee_with_confirmed_user, account: account, first_name: 'Post author').tap do |e|
      create(:membership, organization: organization, employee: e)
    end
  end

  # coworker is a member of the organization of the post
  let(:coworker) do
    create(:employee_with_confirmed_user, account: account, first_name: 'Coworker').tap do |e|
      create(:membership, organization: organization, employee: e)
    end
  end
  let(:unconfirmed_coworker) do
    create(:employee_with_unconfirmed_user, account: account, first_name: 'Unconfirmed Coworker').tap do |e|
      create(:membership, organization: organization, employee: e)
    end
  end
  let(:coworker_without_user) do
    create(:employee, account: account, first_name: 'Coworker without user').tap do |e|
      create(:membership, organization: organization, employee: e)
    end
  end

  let(:other_employee) do
    create(:employee_with_confirmed_user, account: account, first_name: 'Other employee').tap do |e|
      create(:membership, organization: other_organization, employee: e)
    end
  end

  let(:owner) do
    create(:employee_owner, account: account, user: create(:confirmed_user))
  end

  it "creates the expected total number of notifications" do
    coworker
    author
    unconfirmed_coworker
    coworker_without_user
    other_employee

    expect do
      dispatcher.create_notifications!
    end.to change(notification_class, :count).from(0).to(2) # post author is notified, too
  end

  context "#create_notifications!" do

    let(:notifications) do
      notification_class.where(employee_id: the_employee.id,
        notifiable_id: origin.id, notifiable_type: 'Comment')
    end

    context "for a confirmed coworker" do
      let!(:the_employee) { coworker }

      it_behaves_like :creating_a_comment_on_post_notification_for_the_employee
    end

    context "for the author of the comment" do
      let!(:the_employee) { author }

      it_behaves_like :not_creating_a_comment_on_post_notification_for_the_employee
    end

    context "for the author of the post" do
      let!(:the_employee) { post_author }
      let!(:notification_class) { Notification::CommentOnPostOfEmployee }

      it_behaves_like :creating_a_comment_on_post_notification_for_the_employee
    end

    context "for the owner not being a member but the post author" do
      let!(:the_employee) { owner }
      let!(:post_author) { owner }
      let!(:notification_class) { Notification::CommentOnPostOfEmployee }

      it_behaves_like :creating_a_comment_on_post_notification_for_the_employee
    end

    context "for the owner not being a member but a commenter" do
      let!(:the_employee) { owner }
      let!(:another_comment) do
        Comment.build_from(post, the_employee, body: 'a comment').tap(&:save!)
      end
      let!(:notification_class) { Notification::CommentOnPostForCommenter }

      it_behaves_like :creating_a_comment_on_post_notification_for_the_employee
    end

    context "for an unconfirmed coworker" do
      let!(:the_employee) { unconfirmed_coworker }
      it_behaves_like :not_creating_a_comment_on_post_notification_for_the_employee
    end

    context "for a coworker without a user" do
      let!(:the_employee) { coworker_without_user }
      it_behaves_like :not_creating_a_comment_on_post_notification_for_the_employee
    end

    context "for an employee of a different organization" do
      let!(:the_employee) { other_employee }
      it_behaves_like :not_creating_a_comment_on_post_notification_for_the_employee
    end

    context "#recipients" do
      it "does not return duplicates" do
        org = instance_double('Organization')
        dispatcher.stub(:organization).and_return(org)
        org.stub(employees: [coworker, coworker])
        dispatcher.send(:recipients).should == [coworker, post_author]
      end
    end

  end
end
