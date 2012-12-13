require 'spec_helper'

describe Notification::Post do
  let(:notification) { described_class.new notifiable: create(:post) }
  it_should_behave_like 'Notification for Dashboard'
end
