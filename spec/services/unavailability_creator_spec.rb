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
      before :each do
        $want_pry = false
      end

      describe 'given as list' do
        it 'creates an Una for every id' do
          $want_pry = true
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

