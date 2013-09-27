require 'spec_helper'

describe Scheduling do
  describe 'has_conflicts?' do
    it 'is false for lone scheduling' do
      create(:scheduling).should_not be_conflicting
    end
    it 'is false for no overlapping scheduling' do
      create(:scheduling_by_quickie, quickie: '9-10')
      create(:scheduling_by_quickie, quickie: '10-11').should_not be_conflicting
    end
    it 'is true for scheduling covering start'
    it 'is true for scheduling covering end'
  end
end
