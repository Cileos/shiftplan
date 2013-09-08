require 'gravatar_updater'

describe GravatarUpdater do
  let(:record) { stub 'Record' }

  describe '#update' do
    before :each do
      record.stub gravatar_url: (gravatar_url = stub('gravatar_url'))
      record.should_receive(:remote_avatar_url=).with(gravatar_url)
    end
    it 'fetches and stores gravatar when one of record#email exists' do
      record.should_receive(:save!)
      subject.update(record, size: 400)
    end

    it 'catches 404 from gravatar.com' do
      error = OpenURI::HTTPError.new('not found', stub)
      record.should_receive(:save!).and_raise( error )
      logger = stub "Logger"
      logger.should_receive(:warn)
      expect {
        subject.update(record, size: 400, logger: logger)
      }.to_not raise_error
    end
  end

  describe '#update_all' do
    let(:list)   { [record] }

    it 'updates record having no avatar' do
      record.stub avatar?: false
      subject.should_receive(:update).with(record)
      subject.update_all list
    end

    it 'ignores record already having an avatar' do
      record.stub avatar?: true
      subject.should_not_receive(:update)
      subject.update_all list
    end
  end


end
