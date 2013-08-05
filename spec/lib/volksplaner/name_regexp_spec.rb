require 'volksplaner'

describe 'Volksplaner::NameRegEx' do
  subject { Volksplaner::NameRegEx }

  it 'allows numbers IN the name' do
    should match('The21JumpStreet')
  end

  it 'forbids number at the beginning (for friendly id)' do
    should_not match('21JumpStreet')
  end

  it 'allows "&"' do
    should match('R&D')
  end
end
