describe UserConflictFinder do
  it_should_behave_like :conflict_finder_scoped_to_employee
end

describe UserConflictFinder do
  subject { described_class.new schedulings }
  let(:schedulings) { [ scheduling ] }

  def s(quickie, employee)
    create :scheduling_by_quickie, quickie: quickie, employee: employee
  end

  describe 'for different employees by same user' do
    let(:user) { create :user }
    let(:employee) { create :employee, user: user }
    let(:other_employee) { create :employee, user: user }

    describe 'overlapping' do
      let!(:other) { s '7-10', other_employee }
      let(:scheduling) { s '9-17', employee }
      it_should_behave_like :conflict_finder_finding_conflict
    end

    describe 'not overlapping' do
      let!(:other) { s '7-9', other_employee }
      let(:scheduling) { s '9-17', employee }
      it_should_behave_like :conflict_finder_not_finding_conflicts
    end

  end

end
