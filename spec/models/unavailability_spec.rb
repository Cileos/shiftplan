require 'spec_helper'

describe Unavailability do
  describe '#account_ids' do
    it 'is saved in the model' do
      ids = [1,2,3,42,77]
      created = create :unavailability, account_ids: ids
      reloaded = described_class.find created.id
      reloaded.account_ids.should == ids
    end

    it 'must be empty when #employee is set' do
      una = build(:unavailability, account_ids: [1,2,3], employee: build(:employee))
      una.should_not be_valid
      una.should have_at_least(1).error_on(:account_ids)
    end
  end

  describe '#user_id' do
    it 'is set from employee' do
      user     = create :user
      employee = create :employee, user: user
      una      = create :unavailability, employee: employee

      una.user.should == user
    end
  end

  it_behaves_like :spanning_all_day do
    let(:record) { create :unavailability, all_day: true }
  end
end
