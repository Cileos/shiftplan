require 'avatar_widget'

describe AvatarWidget do
  let(:view)     { double('View').as_null_object }
  let(:user)     { double('User') }
  let(:employee) { double('employee') }
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
    let(:html_options) { double 'calculated options' }
    let(:avatar_url) { double 'avatar_url' }
    let(:avatar) { double 'AvatarUploader file', url: avatar_url }
    before :each do
      widget.stub html_options: html_options
    end
    it 'uses uploaded avatar when present' do
      employee.stub avatar?: true, avatar: avatar
      view.should_receive(:image_tag).with(avatar_url, html_options)
      widget.to_html
    end

    context 'for user having cached gravatar' do
      before :each do
        user.stub avatar?: true, avatar: avatar
      end
      context 'for employee without avatar' do
        before :each do
          employee.stub avatar?: false
        end
        it 'uses user#avatar' do
          view.should_receive(:image_tag).with(avatar_url, html_options)
          widget.to_html
        end
      end

      context 'without employee present' do
        let(:employee) { nil }
        before :each do
          user.stub find_employee_with_avatar: nil
        end
        it 'uses user#avatar' do
          view.should_receive(:image_tag).with(avatar_url, html_options)
          widget.to_html
        end
      end
    end

    context 'without employee and user' do
      let(:html_options) { {class: 'given'} }
      let(:user) { nil }
      let(:employee) { nil }
      it 'renders blank fallback user icon' do
        view.should_receive(:content_tag).with(:i, '', class: 'given fallback')
        widget.to_html
      end
    end


    it 'uses employee initials as fallback' do
      employee.stub avatar?: false, shortcut: 'ThC'
      user.stub avatar?: false
      view.should_receive(:content_tag).with(:i, 'ThC', html_options)
      widget.to_html
    end
  end


end
