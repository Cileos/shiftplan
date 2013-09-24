describe IcalExport do
  let(:user) { double 'User' }
  subject { described_class.new(user) }

  describe '#active?' do
    it 'is false for user without private token' do
      user.stub private_token: nil
      subject.should_not be_active
    end

    it 'is false for user with blank private token' do
      user.stub private_token: ''
      subject.should_not be_active
    end

    it 'is true for user with private token' do
      user.stub private_token: 'trolololol'
      subject.should be_active
    end
  end

  describe '#save' do
    it 'generates new private token for user and saves him' do
      token = double '20 char token'
      Volksplaner.stub token_generator_20: lambda { token }
      user.should_receive(:private_token=).with(token)
      user.should_receive(:save!)

      subject.save
    end
  end
end
