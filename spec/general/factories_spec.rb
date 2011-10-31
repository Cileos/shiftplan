require 'spec_helper'

describe Factory do

  FactoryGirl.factories.each do |factory|
    context "Factory #{factory.name}" do
      it "should build valid record" do
        Factory.build(factory.name).should be_valid
      end

      it "should successfully create record" do
        expect { @record = Factory(factory.name) }.not_to raise_error
        @record.should_not be_new_record
        @record.should be_valid
      end
    end
  end

end
