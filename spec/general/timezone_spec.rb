require 'spec_helper'

RSpec::Matchers.define :contain_line_matching do |excepted_line|
  match do |filename|
    File.read(filename).lines.any? { |line| line.match(excepted_line) }
  end
end

describe 'parsing Times' do
  let(:all_spec_files) { Dir[ Rails.root/'spec'/'**'/'*.rb' ] }
  let(:all_spec_files_except_this) { all_spec_files - [__FILE__] }
  it "should never be done with DateTime.parse, but with Time.zone.parse instead" do
    all_spec_files_except_this.each do |file|
      file.should_not contain_line_matching(/^[^#]*DateTime.parse/)
    end
  end
end
