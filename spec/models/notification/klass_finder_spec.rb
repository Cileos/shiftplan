describe Notification::KlassFinder do

  let(:finder) { described_class.new }
  let(:klass)  { finder.find(notifiable, recipient) }

  context "#find" do

    context "when the notifiable is a post" do

      let(:notifiable) { create(:post) }
      let(:recipient)  { instance_double('Employee') }

      it "always finds the Notification::Post class" do
        klass.should == Notification::Post
      end

    end

    context "when the notifiable is a comment" do

      context "when a post was commented" do

        let(:notifiable) do
          Comment.build_from(post, author, body: 'a comment').tap(&:save!)
        end
        let(:post)                { create(:post, blog: blog, author: post_author) }
        let(:blog)                { create(:blog, organization: organization) }
        let(:organization)        { create(:organization, account: account) }
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

        context "when the recipient is the author of the post" do
          let(:recipient) { post_author }

          it "finds the Notification::CommentOnPostOfEmployee class" do
            klass.should == Notification::CommentOnPostOfEmployee
          end

        end

        context "when the recipient is a commenter of the post" do
          let(:commenter) do
            create(:employee_with_confirmed_user, account: account, first_name: 'Commenter').tap do |e|
              create(:membership, organization: organization, employee: e)
              Comment.build_from(post, e, body: 'another comment').tap(&:save!)
            end
          end
          let(:recipient) { commenter }

          it "finds the Notification::CommentOnPostForCommenter class" do
            klass.should == Notification::CommentOnPostForCommenter
          end

        end

        context "when the recipient is a member of the organization" do
          let(:recipient) do
            create(:employee_with_confirmed_user, account: account, first_name: 'Coworker').tap do |e|
              create(:membership, organization: organization, employee: e)
            end
          end

          it "finds the Notification::CommentOnPost class" do
            klass.should == Notification::CommentOnPost
          end

        end

      end

      context "when a scheduling was commented" do
        let(:notifiable) do
          Comment.build_from(scheduling, author, body: 'some text').tap(&:save!)
        end

        let(:scheduling) do
          create(:scheduling, employee: scheduled_employee, plan: plan)
        end
        let(:scheduled_employee) do
          create(:employee_with_confirmed_user, account: account).tap do |e|
            create(:membership, organization: organization, employee: e)
          end
        end

        let(:plan)                { create(:plan, organization: organization) }
        let(:organization)        { create(:organization, account: account) }
        let(:account)             { create(:account) }

        let(:author) do
          create(:employee_with_confirmed_user, account: account).tap do |e|
            create(:membership, organization: organization, employee: e)
          end
        end

        context "when the comment is not an answer" do

          context "when the recipient is the scheduled employee" do
            let(:recipient) { scheduled_employee }

            it "finds the Notification::CommentOnSchedulingOfEmployee" do
              klass.should == Notification::CommentOnSchedulingOfEmployee
            end
          end

          context "when the recipient is a commenter of the scheduling" do
            let(:commenter) do
              create(:employee_with_confirmed_user, account: account).tap do |e|
                create(:membership, organization: organization, employee: e)
                Comment.build_from(scheduling, e, body: 'some text').tap(&:save!)
              end
            end
            let(:recipient) { commenter }


            it "finds the Notification::CommentOnSchedulingForCommenter" do
              klass.should == Notification::CommentOnSchedulingForCommenter
            end
          end

          context "when the recipient is a member of the organization" do
            let(:coworker) do
              create(:employee_with_confirmed_user, account: account).tap do |e|
                create(:membership, organization: organization, employee: e)
              end
            end
            let(:recipient) { coworker }

            it "finds the Notification::CommentOnScheduling" do
              klass.should == Notification::CommentOnScheduling
            end
          end

        end

        context "when the comment is an answer" do

          let(:notifiable) do
            Comment.build_from(scheduling, author, body: 'some text', parent: parent_comment).tap(&:save!)
          end
          let(:parent_comment) do
            Comment.build_from(scheduling, parent_author, body: 'some text').tap(&:save!)
          end
          let(:parent_author) do
            create(:employee_with_confirmed_user, account: account).tap do |e|
              create(:membership, organization: organization, employee: e)
            end
          end

          let(:recipient) do
            create(:employee_with_confirmed_user, account: account).tap do |e|
              create(:membership, organization: organization, employee: e)
            end
          end

          it "finds the Notification::AnswerOnCommentOnScheduling" do
            klass.should == Notification::AnswerOnCommentOnScheduling
          end

          context "and the recipient is the scheduled employee" do

            let(:recipient) { scheduled_employee }

            it "finds the Notification::AnswerOnCommentOnSchedulingOfEmployee" do
              klass.should == Notification::AnswerOnCommentOnSchedulingOfEmployee
            end

            context "and the scheduled employee is the author of the parent comment" do

              let(:parent_author) { recipient }

              it "finds the Notification::AnswerOnCommentOfEmployeeOnSchedulingOfEmployee" do
                klass.should == Notification::AnswerOnCommentOfEmployeeOnSchedulingOfEmployee
              end

            end

          end

          context "and the recipient is a commenter of the scheduling" do

            let(:commenter) do
              create(:employee_with_confirmed_user, account: account).tap do |e|
                create(:membership, organization: organization, employee: e)
                Comment.build_from(scheduling, e, body: 'some text').tap(&:save!)
              end
            end
            let(:recipient) { commenter }

            it "finds the Notification::AnswerOnCommentOnSchedulingForCommenter" do
              klass.should == Notification::AnswerOnCommentOnSchedulingForCommenter
            end

            context "and the recipient is the author of the parent comment" do

              let(:parent_author) { commenter }

              it "finds the Notification::AnswerOnCommentOfEmployeeOnScheduling" do
                klass.should == Notification::AnswerOnCommentOfEmployeeOnScheduling
              end

            end

          end

        end

      end

    end

  end
end
