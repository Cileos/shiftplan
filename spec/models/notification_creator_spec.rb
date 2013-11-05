describe NotificationCreator do

  shared_examples :delegating_notification_creation_to_dispatcher do
    it "dispatcher creates notifications for origin" do
      dispatcher_class.stub(:new).with(origin).and_return(dispatcher)
      dispatcher.should_receive(:create_notifications!)

      creator.create!
    end
  end

  let(:creator) { described_class.new(origin) }
  let(:dispatcher) { instance_double(dispatcher_class.name) }

  context "#create!" do

    context "for a comment on a scheduling" do
      it_behaves_like :delegating_notification_creation_to_dispatcher do
        let(:origin) do
          Comment.build_from(create(:scheduling), Employee.new, body: 'some text')
        end
        let(:dispatcher_class) { Notification::Dispatcher::CommentOnScheduling }
      end
    end

    context "for an answer on a comment on a scheduling" do
      it_behaves_like :delegating_notification_creation_to_dispatcher do
        let(:parent_comment) do
          Comment.build_from(create(:scheduling), Employee.new, body: 'some text')
        end
        let(:origin) do
          Comment.build_from(create(:scheduling), Employee.new,
            body: 'some text', parent: parent_comment)
        end
        let(:dispatcher_class) { Notification::Dispatcher::AnswerOnCommentOnScheduling }
      end
    end

    context "for a comment on a post" do
      it_behaves_like :delegating_notification_creation_to_dispatcher do
        let(:origin) do
          Comment.build_from(create(:post), Employee.new, body: 'some text')
        end
        let(:dispatcher_class) { Notification::Dispatcher::CommentOnPost }
      end
    end

    context "for a post" do
      it_behaves_like :delegating_notification_creation_to_dispatcher do
        let(:origin) { build(:post) }
        let(:dispatcher_class) { Notification::Dispatcher::Post }
      end
    end
  end
end
