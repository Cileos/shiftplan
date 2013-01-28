require 'spec_helper'

describe Notification::Comment do
  let(:notification) { decribed_class.new notifiable: create(:comment) }
end
