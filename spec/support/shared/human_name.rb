shared_examples :human_name_attribute do
  # needs
  #    * :factory_name
  #    * :attr
  it "is needed" do
    build(factory_name, attr => nil).should be_invalid
    build(factory_name, attr => '').should  be_invalid
    build(factory_name, attr => ' ').should be_invalid
  end

  it "may not start with a dot" do # causes translate_action
    build(factory_name, attr => '.lookslikeaction').should be_invalid
  end

  it "may not start with a dash" do # looks ugly
    build(factory_name, attr => '-in').should be_invalid
  end

  it "may not start with an apostrophe" do # until the klingons come
    build(factory_name, attr => "'thal").should be_invalid
  end

  it "may contain dashes" do
    build(factory_name, attr => 'Hans-Peter').should be_valid
  end

  it "may contain apostrophes" do
    build(factory_name, attr => "Mc'Feeling").should be_valid
  end
end

