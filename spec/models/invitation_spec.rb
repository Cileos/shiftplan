# encoding: utf-8
require 'spec_helper'

describe Invitation do
  describe '#associate_employee_with_user' do
    let(:employee)   { create :employee }
    let(:user)       { create :user }
    let(:invitation) { create(:invitation, employee: employee) }
    describe 'when user is set' do
      let(:setting_user) { lambda {
        invitation.user = user
        invitation.send :associate_employee_with_user
      }}
      it 'associates the user to the employee' do
        expect(setting_user).to change { employee.reload.user }.from(nil).to(user)
      end

      it "adds the employee to the user's list of employees" do
        expect(setting_user).to change { user.reload.employees.count }.from(0).to(1)

        user.employees.should include(employee)
      end

      it 'associates existing unavailabilities of the employee to the user' do # so he can edit them
        una = create :unavailability, employee: employee
        expect(setting_user).to change { una.reload.user }.from(nil).to(user)
      end
    end
  end

  it 'must have an email' do
    invitation = build(:invitation, email: nil)

    invitation.should_not be_valid
    invitation.should have(1).errors_on(:email)
  end

  it 'must have a valid email' do
    invitation = build(:invitation, email: 'fnørd..d.@p0x.asdt')

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

        it 'is not valid' do
          invitation_for_bart.should_not be_valid
          invitation_for_bart.should have(1).errors_on(:email)
          invitation_for_bart.errors[:email].should == ['wurde bereits in einer Einladung verwendet.']
        end
      end

      context 'within different account' do
        let(:account_2)      { create :account }
        # organization of a different account
        let(:organization_2) { create :organization, account: account_2 }

        it 'is valid' do
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

        it 'is not valid' do
          invitation_for_bart.should_not be_valid
          invitation_for_bart.should have(1).errors_on(:email)
          invitation_for_bart.errors[:email].should == ['ist bereits einem Ihrer Mitarbeiter zugeordnet.']
        end

        context 'using different case on email' do
          it 'is not valid' do
            invitation_for_bart.email = 'TheSimpsons@springfield.com' # like email, but with CAPS
            invitation_for_bart.should_not be_valid
            invitation_for_bart.should have(1).errors_on(:email)
            invitation_for_bart.errors[:email].should == ['ist bereits einem Ihrer Mitarbeiter zugeordnet.']
          end
        end
      end

      context 'within different account' do
        let(:account_2)   { create :account }
        # organization of a different account
        let(:organization_2) { create :organization, account: account_2 }

        it 'is valid' do
          invitation_for_bart.should be_valid
        end
      end

    end
  end
end
