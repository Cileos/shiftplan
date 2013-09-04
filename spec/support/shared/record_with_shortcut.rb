
# needed lets: :record, :shortcut
shared_examples :record_with_shortcut do
  it "is set automatically" do
    record.shortcut.should_not be_blank
  end
  it "is generated automatically" do
    record.shortcut.should == shortcut
  end
end
