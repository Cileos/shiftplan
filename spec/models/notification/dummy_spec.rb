require 'spec_helper'

describe Notification::Dummy  do
  let(:notification) { described_class.new employee: build(:employee) }
  it_should_behave_like 'Notification for Dashboard'
end

