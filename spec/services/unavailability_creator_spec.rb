require 'spec_helper'

describe UnavailabilityCreator do
  let(:controller)  do
    instance_double('UnavailabilitiesController',
      authorize!: true,
      current_user: current_user)
  end
  subject           { described_class.new controller }
  let(:current_user)        { create :user }

  def create_with_defaults(attrs={})
    subject.call attributes_for(:unavailability).merge(attrs)
  end

  describe "when self planning" do
    # The employee is not present in the params. The employee will be determined
    # via the account ids for each created una instead.

    describe '#account_ids' do
      let(:accounts) { 3.times.map { create :account } }
      before :each do
        accounts.each do |account|
          create :employee, user: current_user, account: account
        end
      end

      describe 'given as list' do
        it 'creates an Una for every id' do
          expect {
            create_with_defaults account_ids: accounts.map(&:id).first(2)
          }.to change { Unavailability.count }.by(2)

          Unavailability.pluck('DISTINCT employee_id').should have(2).records
          subject.created_records.should have(2).records
        end
      end

      describe 'given as empty list on creation' do
        it 'creates an Una for every account user has employee in' do
          expect {
            create_with_defaults
          }.to change { Unavailability.count }.by(3)

          Unavailability.pluck('DISTINCT employee_id').should have(3).records
          subject.created_records.should have(3).records
        end

        it 'does not create any copies when employee is already set' do
          expect {
            create_with_defaults employee: Employee.first
          }.to change { Unavailability.count }.by(1)
          subject.created_records.should have(1).record
        end
      end
    end
  end

  describe 'ranging over multiple days' do
    let(:starts_at) { '2019-05-02 06:00' }
    let(:ends_at)   { '2019-05-06 18:00' }
    before :each do
      account = create :account
      create :employee, user: current_user, account: account
    end
    let(:creation)  { create_with_defaults starts_at: starts_at, ends_at: ends_at }
    it 'creates an una for every day covered' do
      expect { creation }.to change { Unavailability.count }.by(5)
      creation.created_records.map(&:starts_at).map(&:day).should == [2,3,4,5,6]
    end
    it 'uses the same start time on all unas' do
      creation.created_records.each do |record|
        record.start_time.should == '06:00'
      end
    end
    it 'uses the same end time on all unas' do
      creation.created_records.each do |record|
        record.end_time.should == '18:00'
      end
    end
  end

  describe 'ranging over multiple months' do

    let(:starts_at) { '2019-05-23 06:00' }
    let(:ends_at)   { '2019-06-03 18:00' }
    let(:creation)  { create_with_defaults starts_at: starts_at, ends_at: ends_at }

    before :each do
      account = create :account
      create :employee, user: current_user, account: account
    end

    it 'creates an una for every day covered' do
      expect { creation }.to change { Unavailability.count }.by(12)
      Unavailability.all.to_a.each_cons(2) do |a,b|
        (b.starts_at - a.starts_at).should == 1.day
      end
    end
  end

  describe "when planning other employee" do
    # The employee is present and the user will be set to the employee's user
    # (if any). No account ids are present.
    let(:other_user)     { create(:user) }
    let(:other_employee) { create(:employee, user: other_user)}

    it "sets the user to the employee's user" do
      expect {
        create_with_defaults employee: other_employee
      }.to change { Unavailability.count }.from(0).to(1)
      subject.created_records.should have(1).record

      una = Unavailability.last
      una.employee.should == other_employee
      una.user.should == other_employee.user
    end
  end

  describe '#call' do
    it 'checks authorization' do
      controller.should_receive(:authorize!).with(:create, an_instance_of(Unavailability)).and_raise(CanCan::AccessDenied)

      expect { create_with_defaults(employee: Employee.new) }.to raise_error(CanCan::AccessDenied)
    end
  end

end

