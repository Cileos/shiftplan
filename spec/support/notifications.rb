shared_examples 'Notification for Dashboard' do
  # must let(:notification) in your example

  it "should have subject implemented" do
    expect { notification.subject }.not_to raise_error(NotImplementedError)
  end

  it "should have introductory_text implemented" do
    expect { notification.introductory_text }.not_to raise_error(NotImplementedError)
  end

  it "should have acting_employee implemented" do
    expect { notification.acting_employee }.not_to raise_error(NotImplementedError)
  end

  it "should have a mail subject" do
    notification.mail_subject.should be_present
  end

  it "should have a introductory_text" do
    notification.introductory_text.should be_present
  end

  it "should have a subject" do
    notification.subject.should be_present
  end

  it "should have a blurb" do
    notification.blurb.should be_present
  end

  it "should have a acting_employee" do
    notification.acting_employee.should be_a(Employee)
  end
end
