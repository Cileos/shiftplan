require 'spec_helper'

describe ConflictFinder do
  it_should_behave_like :conflict_finder_scoped_to_employee

  describe 'with scheduling at same time of the same user' do
    subject { described_class.new schedulings }
    let(:employee) { create :employee_with_confirmed_user, account: account }
    let(:account) { create :account }
    let(:schedulings) { [ scheduling ] }
    let(:employee_in_other_account) { create :employee, user: employee.user }
    let(:scheduling) { s '11-12', employee }
    it "has users to associate through" do
      employee.user.should be_present
      employee_in_other_account.user.should be_present
    end
    context 'with represents_unavailability flag set' do
      let!(:other) { s '11-12', employee_in_other_account, represents_unavailability: true }
      it_should_behave_like :conflict_finder_finding_conflict
    end
    context 'with represents_unavailability flag unset' do
      let!(:other) { s '11-12', employee_in_other_account, represents_unavailability: false }
      it_should_behave_like :conflict_finder_not_finding_conflicts
    end
  end
end
