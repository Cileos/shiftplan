require 'spec_helper'

describe Unavailability do
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
