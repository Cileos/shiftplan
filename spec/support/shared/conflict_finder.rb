# subject: conflict findeer
# needs :scheduling, :other

shared_examples :conflict_finder_not_finding_conflicts do
  before { subject.call }

  it 'does not find any conflicts' do
    scheduling.conflicts.should be_blank
    subject.conflicts.should be_blank
  end
end

shared_examples :conflict_finder_finding_conflict do
  before { subject.call }

  it 'finds the conflict' do
    scheduling.conflicts.should_not be_blank
    scheduling.conflicts.should include(other)
  end

  it 'builds conflict objects' do
    subject.conflicts.should have(1).record
  end

  describe 'the found conflict' do
    let(:conflict) { subject.conflicts.first }
    it 'has input scheduling as provoker' do
      conflict.provoker.should == scheduling
    end

    it 'has conflicting schedulings as established' do
      conflict.established.should include(other)
    end
  end
end

shared_examples :conflict_finder_scoped_to_employee do
  subject { described_class.new schedulings }
  let(:employee) { create :employee }
  let(:other_employee) { create :employee }
  let(:schedulings) { [ scheduling ] }

  def s(quickie, employee)
    create :scheduling_by_quickie, quickie: quickie, employee: employee
  end

  describe 'for lone scheduling' do
    let(:scheduling) { create :scheduling }
    it_should_behave_like :conflict_finder_not_finding_conflicts
  end

  describe 'for no overlapping scheduling for same employee' do
    let!(:other) { s '7-9', employee }
    let(:scheduling) { s '9-17', employee }
    it_should_behave_like :conflict_finder_not_finding_conflicts
  end

  describe 'for overlapping scheduling of other employee' do
    let!(:other) { s '7-9', other_employee }
    let(:scheduling) { s '9-17', employee }
    it_should_behave_like :conflict_finder_not_finding_conflicts
  end

  describe 'for scheduling having start covered' do
    let!(:other) { s '9-11', employee }
    let(:scheduling) { s '10-12', employee }
    it_should_behave_like :conflict_finder_finding_conflict
  end

  describe 'for scheduling having end covered' do
    let!(:other) { s '11-13', employee }
    let(:scheduling) { s '10-12', employee }
    it_should_behave_like :conflict_finder_finding_conflict
  end

  describe 'for scheduling covering another' do
    let!(:other) { s '10-13', employee }
    let(:scheduling) { s '11-12', employee }
    it_should_behave_like :conflict_finder_finding_conflict
  end

  describe '.find_conflict_for' do
    let(:other) { instance_double 'Scheduling' }
    let(:scheduling) { instance_double 'Scheduling', :conflicts= => true }
    let!(:finder) { described_class.new([scheduling]) }
    before :each do
      described_class.should_receive(:new).with([scheduling]).and_return(finder)
    end

    describe 'scheduling with conflict' do
      before :each do
        described_class.stub(:new).with([scheduling]).and_return(finder)
        finder.stub(
          conflicts: [found],
          call: true
        )
      end
      let(:found) { double 'Conflict' }

      it 'finds a single conflict for given scheduling' do
        described_class.find_conflict_for(scheduling).should == found
      end
    end

  end
end
