require 'spec_helper'

describe Setup do
  it 'needs first name for employee'
  it 'needs last name for employee'

  context 'execute!' do
    it 'creates account'
    it 'uses default name for account when left blank'
    it 'creates organization'
    it 'uses default name for organization when left blank'
    it 'creates a team for each name'
    it 'creates employee owning the account'
    it 'creates membership for the employee'
    it 'creates plan with default name'
  end
end
