require 'spec_helper'

describe Notification::RecipientsFinder do

  context "#find" do

    let!(:finder) { described_class.new }

    let(:recipients) do
      finder.find(notifiable)
    end

    let!(:author) do
      create(:employee_with_confirmed_user, account: account, first_name: 'Author').tap do |e|
        create(:membership, organization: organization, employee: e)
      end
    end

    let!(:organization)        { create(:organization, account: account) }
    let!(:account)             { create(:account) }
    let(:other_organization)  { create(:organization) }

    let(:blog)                { create(:blog, organization: organization) }


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

    context "when the notifiable is a post" do

      let!(:notifiable)          { create(:post, blog: blog, author: author) }

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
      let(:author) do
        create(:employee_with_confirmed_user, account: account, first_name: 'Author').tap do |e|
          create(:membership, organization: organization, employee: e)
        end
      end

      context "when a scheduling was commented" do

        let(:notifiable) do
          Comment.build_from(scheduling, author, body: 'some text').tap(&:save!)
        end

        let(:scheduling) do
          create(:scheduling, employee: scheduled_employee, plan: plan)
        end

        let(:plan)                { create(:plan, organization: organization) }

        let(:scheduled_employee) do
          create(:employee_with_confirmed_user, account: account, first_name: 'Scheduled employee').tap do |e|
            create(:membership, organization: organization, employee: e)
          end
        end

        let(:planner) do
          create(:employee_with_confirmed_user, account: account, first_name: 'Planner').tap do |e|
            create(:membership, organization: organization, employee: e, role: 'planner')
          end
        end

        let(:commenter) do
          create(:employee_with_confirmed_user, account: account, first_name: 'Commenter').tap do |e|
            create(:membership, organization: organization, employee: e)
            Comment.build_from(scheduling, e, body: 'some text').tap(&:save!)
          end
        end

        let(:planner_without_user) do
          create(:employee, account: account, first_name: 'Planner without user').tap do |e|
            create(:membership, organization: organization, employee: e, role: 'planner')
          end
        end

        let(:planner_with_unconfirmed_user) do
          e = create(:employee_with_unconfirmed_user, account: account,
            first_name: 'Planner with unconfirmed user', shortcut: 'Pu')
          create(:membership, organization: organization, employee: e, role: 'planner')
          e
        end

        it "includes the scheduled employee but not the author" do
          recipients.should == [scheduled_employee]
        end

        it "includes planners" do
          planner

          recipients.should include(planner)
        end

        it "includes commenter" do
          commenter

          recipients.should include(commenter)
        end

        it "does not include planners without user" do
          planner_without_user

          recipients.should_not include(planner_without_user)
        end

        it "does not include planners with unconfirmed user" do
          planner_with_unconfirmed_user

          recipients.should_not include(planner_with_unconfirmed_user)
        end

      end

      context "when a post was commented" do
        let(:notifiable) do
          Comment.build_from(post, author, body: 'a comment').tap(&:save!)
        end

        let(:post) { create(:post, blog: blog, author: post_author) }

        let(:post_author) do
          create(:employee_with_confirmed_user, account: account, first_name: 'Post author').tap do |e|
            create(:membership, organization: organization, employee: e)
          end
        end

        let(:owner) do
          create(:employee_owner, account: account, user: create(:confirmed_user), first_name: 'Owner')
        end

        let(:another_comment) do
          Comment.build_from(post, owner, body: 'a comment').tap(&:save!)
        end

        it "includes the post author but not the author of the comment" do
          recipients.should == [post_author]
        end

        it "includes the members of the organization" do
          coworker

          recipients.should include(coworker)
        end

        it "include the owner who commented" do
          owner
          another_comment

          recipients.should include(owner)
        end

        it "include the owner who is author of the post" do
          post.update_attributes!(author_id: owner.id)

          recipients.should include(owner)
        end

        it "does not include unconfirmed coworkers" do
          unconfirmed_coworker

          recipients.should_not include(unconfirmed_coworker)
        end

        it "does not include coworkers without user" do
          coworker_without_user

          recipients.should_not include(coworker_without_user)
        end

      end
    end

  end
end
