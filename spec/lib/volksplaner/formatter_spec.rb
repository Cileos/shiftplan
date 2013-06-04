# encoding: utf-8
require 'spec_helper'

describe Volksplaner::Formatter do
  context '.human_hours' do
    it 'formats full hours' do
      described_class.human_hours(5).should == '5'
    end

    it 'formats quarter of an hour' do
      described_class.human_hours(4.25).should == '4¼'
    end

    it 'formats half hours' do
      described_class.human_hours(3.5).should == '3½'
    end

    it 'formats three quarter hours' do
      described_class.human_hours(1.75).should == '1¾'
    end
  end

  context '.metric_hour_string' do
    it 'formats full hours' do
      described_class.metric_hour_string(5).should == '5'
    end

    it 'formats quarter of an hour' do
      described_class.metric_hour_string(4.25).should == '4.25'
    end

    it 'formats half hours' do
      described_class.metric_hour_string(3.5).should == '3.5'
    end

    it 'formats three quarter hours' do
      described_class.metric_hour_string(1.75).should == '1.75'
    end

    it 'cuts of extra decimal places' do
      described_class.metric_hour_string(1.753454).should == '1.75'
    end

  end
end
