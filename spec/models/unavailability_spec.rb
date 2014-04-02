require 'spec_helper'

describe Unavailability do
  describe '#account_ids' do
    it 'is saved in the model' do
      ids = [1,2,3,42,77]
      created = create :unavailability, account_ids: ids
      reloaded = described_class.find created.id
      reloaded.account_ids.should == ids
    end
  end
end
