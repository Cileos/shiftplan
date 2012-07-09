require 'spec_helper'

describe User do

  describe 'having role planner' do
    let(:planner) { create(:employee_planner, user: create(:user)) }

    it { planner.should be_a_planner }
    it { planner.should be_role('planner') }
  end
end
