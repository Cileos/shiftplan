describe TwoDimensionalRecordIndex, 'for attributes :a and :b' do

  let(:index) { described_class.new(:a, :b) }

  it "groups records by :a" do
    index << stub(a: 'red', b: 'small')
    index << stub(a: 'blue', b: 'small')
    index.keys.should == ['red','blue']
  end

  it "accepts an array" do
    one, two = stub, stub
    index.should_receive(:add_record).with(one)
    index.should_receive(:add_record).with(two)
    index << [one,two]
  end

  it "adds records with chaining" do
    records = stub
    index.should_receive(:<<).with(records)
    index.with_records_added(records).should == index
  end

  describe "having records with similar :a by :b" do
    let(:small) { stub(a: 'red', b: 'small') }
    let(:big)   { stub(a: 'red', b: 'big')  }
    before :each do
      index << small
      index << big
    end

    it "groups by :a first" do
      index.keys.should == ['red']
      index['red'].keys.should == ['small','big']
    end

    it "groups by :b after :a" do
      index['red']['small'].should == [small]
      index['red']['big'].should == [big]
    end

    it "can fetch by values for :a, :b" do
      index.fetch('red', 'small').should == [small]
      index.fetch('red', 'big').should == [big]
    end

    it "does not fill holes" do
      index['red']['huge'].should be_nil
    end

    it "gives empty array for unknown color" do
      index.fetch('green', 'foo').should == []
    end

    it "gives empty array for unknown size" do
      index.fetch('red', 'huge').should == []
    end

  end
end
