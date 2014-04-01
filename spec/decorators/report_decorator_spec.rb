require 'spec_helper'

describe ReportDecorator do

  let(:report)    { Report.new }
  let(:decorator) { report.decorate }

  describe "#active_or_not" do

    context "when a current_chunk is present" do

      before do
        decorator.stub(current_chunk: '100')
      end

      it "returns 'active' if the chunk equals the current chunk" do
        decorator.send(:active_or_not, 100).should == 'active'
      end

      it "returns 'false' if the chunk does not equal the current chunk" do
        decorator.send(:active_or_not, 250).should == 'false'
      end
    end

    # When a user initially visits a report page no current chunk(limit param)
    # will be present until she/he used some available filters.
    context "when a current_chunk is not present" do

      before do
        decorator.stub(current_chunk: nil)
        decorator.stub(first_chunk: 50)
      end

      it "returns 'active' if the chunk is the first chunk" do
        decorator.send(:active_or_not, 50).should == 'active'
      end

      it "returns 'false' if the chunk is not the first chunk" do
        decorator.send(:active_or_not, 100).should == 'false'
      end
    end
  end
end
