require 'spec_helper'

describe Team do
  it "should need a name" do
    Factory.build(:team, :name => nil).should be_invalid
    Factory.build(:team, :name => '').should be_invalid
    Factory.build(:team, :name => ' ').should be_invalid
  end

  context 'color' do
    let(:team) { Factory.build(:team) }

    it { team.color.should_not be_blank }
    it { team.color.should =~ /^#[0-9a-f]{6}$/ }
  end

  context 'shortcut' do
    let(:team) { Factory.build(:team, name: "Reaktor putzen" ) }

    it "should be set automatically" do
      team.shortcut.should_not be_blank
    end
    it "should be generated automatically" do
      team.shortcut.should == 'Rp'
    end
    it "should be put in quickie in square brackets" do
      team.stub(:shortcut).and_return('TT')
      team.to_quickie.should == 'Reaktor putzen [TT]'
    end
  end
end
