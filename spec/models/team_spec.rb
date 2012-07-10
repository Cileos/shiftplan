require 'spec_helper'

describe Team do
  it "should need a name" do
    build(:team, :name => nil).should be_invalid
    build(:team, :name => '').should be_invalid
    build(:team, :name => ' ').should be_invalid
    build(:team, :name => 'Totlachen').should be_valid
  end

  context 'color' do
    let(:team) { build(:team) }

    it { team.color.should_not be_blank }
    it { team.color.should =~ /^#[0-9A-F]{6}$/ }
  end

  context 'shortcut' do
    let(:team) { build(:team, name: "Reaktor putzen" ) }

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
