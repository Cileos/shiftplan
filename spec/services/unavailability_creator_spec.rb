require 'spec_helper'

describe UnavailabilityCreator do
  let(:controller) { double 'UnavailabilitiesController', authorize!: true }
  subject { described_class.new controller }
  let(:user) { create :user }

  def create_with_defaults(attrs={})
    subject.call attributes_for(:unavailability).merge(attrs)
  end

  describe '#account_ids' do
    let(:accounts) { 3.times.map { create :account } }
    before :each do
      accounts.each do |account|
        create :employee, user: user, account: account
      end
    end
    before :each do
      $want_pry = false
    end
    describe 'given as list' do
      it 'creates an Una for every id' do
        $want_pry = true
        expect {
          create_with_defaults user: user, account_ids: accounts.map(&:id).first(2)
        }.to change { Unavailability.count }.by(2)

        Unavailability.pluck('DISTINCT employee_id').should have(2).records
        subject.created_records.should have(2).records
      end
    end

    describe 'given as empty list on creation' do
      it 'creates an Una for every account user has employee in' do
        expect {
          create_with_defaults user: user
        }.to change { Unavailability.count }.by(3)

        Unavailability.pluck('DISTINCT employee_id').should have(3).records
        subject.created_records.should have(3).records
      end

      it 'does not create any copies when employee is already set' do
        expect {
          create_with_defaults user: user, employee: Employee.first
        }.to change { Unavailability.count }.by(1)
        subject.created_records.should have(1).record
      end
    end
  end

  describe '#call' do
    it 'checks authorization' do
      controller.should_receive(:authorize!).with(:create, an_instance_of(Unavailability)).and_raise(CanCan::AccessDenied)

      expect { create_with_defaults }.to raise_error(CanCan::AccessDenied)
    end
  end

end

