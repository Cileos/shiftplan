# encoding: utf-8
require 'spec_helper'

describe 'Quickie::parser' do

  describe "hour range" do
    describe '9-17' do
      it { should parse_successfully }
      it { should fill_in(:start_hour, 9) }
      it { should fill_in(:end_hour, 17) }
      it { should serialize_to('9-17') }
    end

    [
      '9-23',
      '0-5',
      '1-2',
      '12-24',
      '20-8'
    ].each do |valid_hour_range|
      describe valid_hour_range do
        it { should parse_successfully }
      end
    end

    [
      '1-',
      '-23',
      '9-25',
      '1-88'
    ].each do |invalid_hour_range|
      describe invalid_hour_range do
        it { should_not parse_successfully }
      end
    end

  end

  describe 'team names' do

    describe 'Abwaschen' do
      it { should parse_successfully }
      it { should fill_in(:team_name, 'Abwaschen') }
      it { should serialize_to('Abwaschen') }
    end

    describe 'The A Team' do
      it { should parse_successfully }
      it { should fill_in(:team_name, 'The A Team') }
      it { should serialize_to('The A Team') }
    end

    describe '  The Space   Rangerz  ' do
      it { should parse_successfully }
      it { should fill_in(:team_name, 'The Space Rangerz') }
      it { should serialize_to('The Space Rangerz') }
    end

    describe 'Brennstäbe wechseln' do
      it { should parse_successfully }
      it { should fill_in(:team_name, 'Brennstäbe wechseln') }
      it { should serialize_to('Brennstäbe wechseln') }
    end

  end

  describe 'team names with shortcuts' do

    describe 'Abwaschen [MEH]' do
      it { should parse_successfully }
      it { should fill_in(:team_name, 'Abwaschen') }
      it { should fill_in(:team_shortcut, 'MEH') }
      it { should serialize_to('Abwaschen [MEH]') }
    end

    describe 'Öl wechseln [Öl]' do
      it { should parse_successfully }
      it { should fill_in(:team_name, 'Öl wechseln') }
      it { should fill_in(:team_shortcut, 'Öl') }
      it { should serialize_to('Öl wechseln [Öl]') }
    end

  end

end

