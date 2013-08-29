require 'avatar_widget'

describe AvatarWidget do
  let(:view)     { stub('View').as_null_object }
  let(:user)     { stub('User') }
  let(:employee) { stub('employee') }
  let(:version)  { :tiny }
  let(:options)  { {class: :author} }
  let(:widget)   { described_class.new(view, user, employee, version, options) }

  describe '#html_options :class' do
    subject { widget.html_options[:class] }
    it { should include('avatar') }
    it { should include('tiny') }
    it { should include('author') }
  end

end
