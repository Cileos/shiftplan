require 'spec_helper'

describe Unavailability do

  it_behaves_like :spanning_all_day do
    let(:record) { create :unavailability, all_day: true }
  end
end
