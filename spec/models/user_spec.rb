require 'spec_helper'

describe User do

  describe 'having role planner' do
    let(:user) { Factory.build :planner }

    it { user.should be_a_planner }
    it { user.should be_role('planner') }
  end
end
