require 'spec_helper'

describe User do

  describe 'having role planner' do
    let(:planner) { Factory(:planner, user: Factory(:user)) }

    it { planner.should be_a_planner }
    it { planner.should be_role('planner') }
  end
end
