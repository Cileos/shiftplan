require 'spec_helper'

describe Comment do

  let(:comment) do
    Comment.build_from(create(:scheduling), create(:employee), body: 'Hallo')
  end

  context "when destroyed" do

    it "notifications are destroyed" do
      comment.save!
      destroyer = instance_double("NotificationDestroyer")
      NotificationDestroyer.should_receive(:new).with(comment).and_return(destroyer)
      destroyer.should_receive(:destroy!)

      comment.destroy
    end
  end

  context "when created" do

    it "notifications are created" do
      creator = instance_double("NotificationCreator")
      NotificationCreator.should_receive(:new).with(comment).and_return(creator)
      creator.should_receive(:create!)

      comment.save!
    end
  end
end
