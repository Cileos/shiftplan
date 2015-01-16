require 'rails_helper'

describe Ember::SchedulingsController do
  describe '#index' do
    context 'without plan_id in params' do
      it "it renders only the current_user's schedulings, but no one else's"
    end

    context 'with plan_id in params' do
      it 'does not bother about current_user when fetching'
    end

    it 'verifies permissions for each returned record'
  end
end
