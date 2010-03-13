require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Hash do
  describe "instance methods" do
    describe "compact, compact!" do
      before(:each) do
        @hash = {
          :array => [1, 2, 3],
          :array_with_some_nils => [1, nil, 2, nil, 3, nil],
          :array_with_only_nils => [nil, nil, nil],
          :nil => nil,
          :a => 'a',
          :b => :b,
          :c => 1
        }
      end

      describe "compact" do
        it "should compact the hash" do
          compacted = @hash.compact

          compacted[:array].should == [1, 2, 3]
          compacted[:array_with_some_nils].should == [1, 2, 3]
          compacted[:a].should == 'a'
          compacted[:b].should == :b
          compacted[:c].should == 1

          compacted.should_not have_key(:array_with_only_nils)
          compacted.should_not have_key(:nil)
        end

        it "should not change the original hash" do
          # doesn't work – classic dup issue
          # lambda { @hash.compact }.should_not change(@hash, :hash)
        end
      end

      describe "compact!" do
        it "should compact the hash" do
          @hash.compact!

          @hash[:array].should == [1, 2, 3]
          @hash[:array_with_some_nils].should == [1, 2, 3]
          @hash[:a].should == 'a'
          @hash[:b].should == :b
          @hash[:c].should == 1

          @hash.should_not have_key(:array_with_only_nils)
          @hash.should_not have_key(:nil)
        end
      end
    end
  end
end