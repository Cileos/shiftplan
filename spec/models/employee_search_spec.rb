require 'spec_helper'

describe EmployeeSearch do
  let(:account)         { create :account }
  let!(:organization)   { create :organization, name: 'Springfield', account: account }

  let!(:user_homer)     { create :confirmed_user, email: 'homer@thesimpsons.com' }
  let!(:employee_homer) { create :employee, account: account, first_name: 'Homer', last_name: 'Simpson', user: user_homer }
  let!(:employee_bart)  { create :employee, account: account, first_name: 'Bart',  last_name: 'Simpson' }
  let!(:employee_carl)  { create :employee, account: account, first_name: 'Carl',  last_name: 'Carlson' }

  let!(:membership_homer) { create :membership, organization: organization, employee: employee_homer }
  let!(:membership_bart)  { create :membership, organization: organization, employee: employee_bart }

  let(:base)            { account.employees }

  context '#new' do
    it 'raises an error when base is missing' do
      expect { EmployeeSearch.new() }.to raise_error
    end
  end

  describe '#results' do
    context 'when only searching by base' do
      let(:search) { EmployeeSearch.new(base: base) }

      it 'returns all results from base scope sorted by names' do
        search.results.should == [employee_carl, employee_bart, employee_homer]
      end
    end

    context 'when searching by first name' do
      let(:search) { EmployeeSearch.new(base: base, first_name: 'Homer') }

      it 'returns employees with matching first name' do
        search.results.should == [employee_homer]
      end
    end

    context 'when searching by last name' do
      let(:search) { EmployeeSearch.new(base: base, last_name: 'Simpson') }

      it 'returns employees with matching last name' do
        search.results.should == [employee_bart, employee_homer]
      end
    end

    context 'when searching by first name and last name' do
      let(:search) { EmployeeSearch.new(base: base, first_name: 'Homer', last_name: 'Simpson') }

      it 'returns employees with matching first and last name' do
        search.results.should == [employee_homer]
      end
    end

    it 'returns [] if no employee matches search attributes' do
      search = EmployeeSearch.new(base: base, first_name: 'Homer', last_name: 'Carlson')
      search.results.should == []
    end
  end

  describe '#fuzzy_results' do
    context 'when only searching by base' do
      let(:search) { EmployeeSearch.new(base: base) }

      it 'returns all results from base scope sorted by names' do
        search.fuzzy_results.should == [employee_carl, employee_bart, employee_homer]
      end
    end

    context 'when searching by first name' do
      let(:search) { EmployeeSearch.new(base: base, first_name: 'Hom') }

      it 'returns employees with matching first name prefix' do
        search.fuzzy_results.should == [employee_homer]
      end
    end

    context 'when searching by last name' do
      let(:search) { EmployeeSearch.new(base: base, last_name: 'Simp') }

      it 'returns employees with matching last name prefix' do
        search.fuzzy_results.should == [employee_bart, employee_homer]
      end
    end

    context 'when searching by lowercase last name' do
      let(:search) { EmployeeSearch.new(base: base, last_name: 'simp') }

      it 'returns employees with matching last name prefix case-insensitive' do
        search.fuzzy_results.should == [employee_bart, employee_homer]
      end
    end

    context 'when searching by email' do
      let(:search) { EmployeeSearch.new(base: base, email: 'homer@thesimpsons') }

      it 'returns employees with matching email prefix' do
        search.fuzzy_results.should == [employee_homer]
      end
    end

    context 'when searching by organization' do
      let(:search) { EmployeeSearch.new(base: base, organization: organization.id) }

      it 'returns employees with matching organization' do
        search.fuzzy_results.should == [employee_bart, employee_homer]
      end
    end

    context 'when searching by first name, last name, email and organization' do
      let(:search) do
        EmployeeSearch.new(
          base:         base,
          first_name:   'Hom',
          last_name:    'Simps',
          email:        'homer@',
          organization: organization.id
        )
      end

      it 'returns employees with matching first name prefix, last name prefix, email prefix and organization' do
        search.fuzzy_results.should == [employee_homer]
      end
    end

    it 'returns [] if no employee matches search attributes' do
      search =  EmployeeSearch.new(base: base, first_name: 'Hom', last_name: 'Carls')
      search.results.should == []
    end
  end
end
