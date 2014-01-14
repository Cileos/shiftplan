require 'spec_helper'

describe Comment do

  context "when destroyed" do

    let(:comment) do
      Comment.build_from(create(:scheduling), create(:employee), body: 'Hallo').tap(&:save!)
    end

    it "notifications are destroyed" do
      destroyer = instance_double("NotificationDestroyer")
      NotificationDestroyer.should_receive(:new).with(comment).and_return(destroyer)
      destroyer.should_receive(:destroy!)

      comment.destroy
    end
  end
end
