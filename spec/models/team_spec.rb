# encoding: utf-8

require 'spec_helper'

describe Team do

  context 'color' do
    let(:team) { build(:team) }

    it { team.color.should_not be_blank }
    it { team.color.should =~ /^#[0-9A-F]{6}$/ }

    it 'may be upper case' do
      build(:team, color: '#AFFE23').should be_valid
    end

    it 'may be lower case' do
      build(:team, color: '#affe23').should be_valid
    end
  end

  context 'name' do
    it "should be needed" do
      build(:team, name: nil).should be_invalid
      build(:team, name: '').should be_invalid
      build(:team, name: ' ').should be_invalid
      build(:team, name: 'Totlachen').should be_valid
    end

    it "accepts Umlauts" do
      build(:team, name: 'Krümelmonster').should be_valid
    end

    it "accepts spaces and numbers" do
      build(:team, name: 'Krümelmonster 2').should be_valid
    end

    it "may not start with a number" do
      build(:team, name: '5arsch').should_not be_valid
    end

    it "should not accept dashes to avoid confusion for Quickie parser" do
      build(:team, name: 'Krümel-monster').should_not be_valid
    end
  end

  context 'shortcut' do
    let(:record) { build(:team, name: "Reaktor putzen" ) }
    let(:shortcut) { 'Rp' }
    it_should_behave_like :record_with_shortcut

    it "is wrapped in square brackets for quickie" do
      record.stub(:shortcut).and_return('TT')
      record.to_quickie.should == 'Reaktor putzen [TT]'
    end
  end
end
