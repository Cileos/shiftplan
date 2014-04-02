require 'spec_helper'

describe Notification::Post do
  let(:notification) { described_class.new notifiable: create(:post) }
  let(:post)         { create :post }

  it_behaves_like 'Notification for Dashboard'
end

