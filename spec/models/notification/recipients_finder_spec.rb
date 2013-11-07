describe Notification::RecipientsFinder do

  context "#find" do

    let!(:finder) { described_class.new }

    let(:recipients) do
      finder.find(notifiable)
    end

    context "when the notifiable is a post" do

      let!(:notifiable)          { create(:post, blog: blog, author: author) }
      let!(:blog)                { create(:blog, organization: organization) }
      let!(:organization)        { create(:organization, account: account) }
      let!(:account)             { create(:account) }

      let!(:author) do
        create(:employee_with_confirmed_user, account: account, first_name: 'Author').tap do |e|
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
        create(:employee, account: account, first_name: 'Coworker without User').tap do |e|
          create(:membership, organization: organization, employee: e)
        end
      end

      let(:other_organization)  { create(:organization, account: account) }

      let(:other_employee) do
        create(:employee_with_confirmed_user, account: account, first_name: 'Other Employee').tap do |e|
          create(:membership, organization: other_organization, employee: e)
        end
      end

      it "does not include the author" do
        recipients.should be_empty
      end

      it "includes the employees of the same organization" do
        coworker # create coworker
        other_employee

        recipients.should == [coworker]
      end

      it "does not include unconfirmed coworkers" do
        unconfirmed_coworker

        recipients.should be_empty
      end

      it "does not include coworkers without user" do
        coworker_without_user

        recipients.should be_empty
      end

    end

    context "when the notifiable is a comment" do
      context "when a scheduling was commented" do

      end

      context "when a post was commented" do

      end
    end

  end
end
