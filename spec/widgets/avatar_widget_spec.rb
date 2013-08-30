require 'avatar_widget'

describe AvatarWidget do
  let(:view)     { stub('View').as_null_object }
  let(:user)     { stub('User') }
  let(:employee) { stub('employee') }
  let(:version)  { :tiny }
  let(:options)  { {class: :author} }
  let(:widget)   { described_class.new(view, user, employee, version, options) }

  describe '#employee' do
    it 'finds an employee with avatar when none given'
  end

  describe '#html_options :class' do
    subject { widget.html_options[:class] }
    it { should include('avatar') }
    it { should include('tiny') }
    it { should include('author') }
  end

  describe '#to_html' do
    let(:html_options) { stub 'calculated options' }
    let(:avatar_url) { stub 'avatar_url' }
    let(:avatar) { stub 'AvatarUploader file', url: avatar_url }
    before :each do
      widget.stub html_options: html_options
    end
    it 'uses uploaded avatar when present' do
      employee.stub avatar?: true, avatar: avatar
      view.should_receive(:image_tag).with(avatar_url, html_options)
      widget.to_html
    end
    it 'uses user#avatar when cached' do
      employee.stub avatar?: false
      user.stub avatar?: true, avatar: avatar
      view.should_receive(:image_tag).with(avatar_url, html_options)
      widget.to_html
    end

    it 'uses employee initials as fallback' do
      employee.stub avatar?: false, shortcut: 'ThC'
      user.stub avatar?: false
      view.should_receive(:content_tag).with(:i, 'ThC', html_options)
      widget.to_html
    end
  end

end
