require 'spec_helper'
require "cancan/matchers"


describe 'Unavailability permissions:' do
  subject              { ability }
  let(:ability)        { Ability.new(user) }
  let(:user)           { build_stubbed(:user) }
  let(:employee)       { build(:employee) }

  describe 'for user' do
    let(:unavailability) { build :unavailability, employee: employee }

    before :each do
      user.stub plannable_employees: []
      user.stub employees: []
    end

    it 'allows me to manage unas for my plannable employees' do
      user.plannable_employees << employee
      should be_able_to(:manage, unavailability)
    end

    it 'allows me to manage unas for my alter ego employees' do
      user.employees << employee
      should be_able_to(:manage, unavailability)
    end

    it 'forbids me to manage unas for any other employe' do
      should_not be_able_to(:manage, unavailability)
    end
  end
end
