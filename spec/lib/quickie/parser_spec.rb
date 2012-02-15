require 'spec_helper'

describe 'Quickie::Parser' do

  RSpec::Matchers.define :parse_successfully do
    match do |string|
      parser = Quickie::Parser.new
      quickie = parser.parse(string)
      quickie != nil
    end
  end

  RSpec::Matchers.define :fill_in do |attr, val|
    def target
      @target ||= OpenStruct.new
    end

    match do |string|
      parser = Quickie::Parser.new
      quickie = parser.parse(string)
      quickie.fill( target )
      target.send(attr) == val
    end

    failure_message_for_should do |actual|
      "excpected that it fills in #{attr} with #{val}, but was #{target.send(attr)}"
    end
  end

  describe '9-17' do
    it { should parse_successfully }
    it { should fill_in(:start_hour, 9) }
    it { should fill_in(:end_hour, 17) }
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

  # reload Grammar manually, because the constant QuickieParser are created
  # automatically on Treetop.load, else spork does not recognize changes
  before(:all) do
    require_dependency 'quickie'
  end
  after(:all) do
    if defined?(QuickieParser)
      Object.send :remove_const, :QuickieParser
    end
    if defined?(Quickie::Parser)
      Quickie.send :remove_const, :Parser
      Object.send :remove_const, :Quickie
    end
  end

end

