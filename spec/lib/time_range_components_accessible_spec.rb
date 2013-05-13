require 'spec_helper'



describe TimeRangeComponentsAccessible do
  before :each do
    class ObjectWithTimeRanges
      stub :before_validation
      attr_accessor :starts_at, :ends_at, :date

      include TimeRangeComponentsAccessible
    end
  end
  let(:m) { ObjectWithTimeRanges.new }

  it 'accepts start_time' do
    m.start_time = '19:59'
    m.start_hour.should == 19
    m.start_minute.should == 59
    m.start_time.should == '19:59'
  end

end
