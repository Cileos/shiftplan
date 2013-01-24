shared_examples 'Notification for Dashboard' do
  # must let(:notification) in your example

  it "should have subject implemented" do
    expect { notification.subject }.to_not raise_error(NotImplementedError)
  end

  it "should have introductory_text implemented" do
    expect { notification.introductory_text }.to_not raise_error(NotImplementedError)
  end

  it "should have acting_employee implemented" do
    expect { notification.acting_employee }.to_not raise_error(NotImplementedError)
  end

  it "should have a subject" do
    notification.subject.should be_present
  end

  it "should have a introductory_text" do
    notification.introductory_text.should be_present
  end

  it "should have a acting_employee" do
    notification.acting_employee.should be_a(Employee)
  end
end
