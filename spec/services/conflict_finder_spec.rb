require 'spec_helper'

describe ConflictFinder do
  it_should_behave_like :conflict_finder_scoped_to_employee

  let(:employee) { create :employee_with_confirmed_user, account: account }
  let(:account) { create :account }
  let(:employee_in_other_account) { create :employee, user: employee.user }

  it "has users to associate through" do
    employee.user.should be_present
    employee_in_other_account.user.should be_present
  end

  describe 'for scheduling at same time' do
    subject { described_class.new schedulings }
    let(:schedulings) { [ scheduling ] }
    let(:scheduling) { s '11-12', employee }

    describe 'when other scheduling of same user exists' do
      context 'with represents_unavailability flag set' do
        let!(:other) { s '11-12', employee_in_other_account, represents_unavailability: true }
        it_should_behave_like :conflict_finder_finding_conflict
      end
      context 'with represents_unavailability flag unset' do
        let!(:other) { s '11-12', employee_in_other_account, represents_unavailability: false }
        it_should_behave_like :conflict_finder_not_finding_conflicts
      end
    end

    describe 'when unavailability of same user exists' do
      let!(:other) { una '11-12', user: employee.user }
      it_should_behave_like :conflict_finder_finding_conflict
    end

    describe 'when unavailability of same employee exists' do
      let!(:other) { una '11-12', employee: employee }
      it_should_behave_like :conflict_finder_finding_conflict
    end

    describe 'when unavailability of employee of same user in other account exists' do
      let!(:other) do
        una '11-12', employee: employee_in_other_account, user: employee_in_other_account.user
      end
      it_should_behave_like :conflict_finder_finding_conflict
    end

    # NEG

    describe 'when unavailability of another user exists' do
      let!(:other) { una '11-12', user: create(:user) }
      it_should_behave_like :conflict_finder_not_finding_conflicts
    end

    describe 'when unavailability of completely different employee exists' do
      let(:foreign_employee) { create(:employee, account: account) }
      let!(:other) { una '11-12', employee: foreign_employee }
      it_should_behave_like :conflict_finder_not_finding_conflicts
    end
  end
end
