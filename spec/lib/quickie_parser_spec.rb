require 'spec_helper'


describe 'QuickieParser' do

  RSpec::Matchers.define :parse_successfully do
    match do |string|
      parser = QuickieParser.new
      quickie = parser.parse(string)
      quickie != nil
    end
  end

  describe '9-17' do
    it { should parse_successfully }
    it "should interpret start_hour"
    it "should interpret end_hour"
    it "should interpret start_hours"
    it "should interpret end_hours"
  end

  [
    '9-23',
    '0-5',
    '1-2',
    '12-24'
  ].each do |valid_hour_range|
    describe valid_hour_range do
      it { should parse_successfully }
    end
  end

  [
    '9-25',
    '1-88'
  ].each do |in_valid_hour_range|
    describe in_valid_hour_range do
      it { should_not parse_successfully }
    end
  end

  before(:each) do
    # load Grammar manually, because require 'quickie' through polyglot only
    # runs once, ergo removing the const will destroy it forever
    if defined?(QuickieParser)
      Object.send :remove_const, :QuickieParser
    end
    Treetop::load (Rails.root/'lib'/'quickie.treetop').to_s
  end

end

