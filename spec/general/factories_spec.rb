require 'spec_helper'

describe 'Factory' do

  FactoryGirl.factories.each do |factory|
    context "for #{factory.name}" do
      it "should build valid record" do
        build(factory.name).should be_valid
      end

      it "should successfully create record" do
        expect { @record = create(factory.name) }.not_to raise_error
        @record.should_not be_new_record
      end
    end
  end

end
