require 'spec_helper'

describe Invitation do
  describe 'associate employee with user' do
    it 'should link the employee to the user on save if user is set' do
      employee = create :employee
      user = create :user
      invitation = create(:invitation, employee: employee, organization: create(:organization))

      employee.user.should be_nil
      user.employees.should be_empty

      invitation.user = user
      invitation.save!

      employee.reload.user.should eql(user)
      user.reload.employees.should include(employee)
    end
  end

  it 'must have an email' do
    invitation = build(:invitation, email: nil)

    invitation.should_not be_valid
    invitation.should have(1).errors_on(:email)
  end

  context 'uniqueness of email within account' do
    in_locale :de

    let(:account_1)      { create :account }
    let(:organization_1) { create :organization, account: account_1 }
    let(:email)          { 'thesimpsons@springfield.com' }
    let(:bart)           { create :employee }
    let(:invitation_for_bart) do
      build(:invitation,
        organization: organization_2,
        employee:     bart,
        email:        email
      )
    end

    context 'when invitation with email exists' do
      let(:homer)          { create :employee }

      let!(:invitation_for_homer) do
        create(:invitation,
          organization: organization_1,
          employee:     homer,
          email:        email
        )
      end

      context 'within same account' do
        # organization within same account
        let(:organization_2) { create :organization, account: account_1 }

        it 'should not be valid' do
          invitation_for_bart.should_not be_valid
          invitation_for_bart.should have(1).errors_on(:email)
          invitation_for_bart.errors[:email].should == ['wurde bereits in einer Einladung verwendet.']
        end
      end

      context 'within different account' do
        let(:account_2)      { create :account }
        # organization of a different account
        let(:organization_2) { create :organization, account: account_2 }

        it 'should be valid' do
          invitation_for_bart.should be_valid
        end
      end
    end

    context 'when user with email exists' do
      let!(:user_homer) { create :user, email: email }
      let!(:homer)      { create :employee, user: user_homer, account: account_1 }
      let!(:membership) { create :membership, organization: organization_1, employee: homer }

      context 'within same account' do
        # organization within same account
        let(:organization_2) { create :organization, account: account_1 }

        it 'should not be valid' do
          invitation_for_bart.should_not be_valid
          invitation_for_bart.should have(1).errors_on(:email)
          invitation_for_bart.errors[:email].should == ['ist bereits einem Ihrer Mitarbeiter zugeordnet.']
        end
      end

      context 'within different account' do
        let(:account_2)   { create :account }
        # organization of a different account
        let(:organization_2) { create :organization, account: account_2 }

        it 'should be valid' do
          invitation_for_bart.should be_valid
        end
      end

    end
  end
end
