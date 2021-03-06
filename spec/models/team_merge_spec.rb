require 'spec_helper'

describe TeamMerge do
  let(:organization) { create :organization }

  describe 'between teams of same organization' do
    let(:team)       { create :team, organization: organization }
    let(:other_team) { create :team, organization: organization }

    def merge(t, ot, nt)
      TeamMerge.new(team_id: t.id, other_team_id: ot.id, new_team_id: nt.id).save
    end

    it "should delete other team" do
      team; other_team
      new_team = team
      expect { merge(team, other_team, new_team) }.to change(Team, :count).by(-1)
      team.reload.should_not be_nil
    end

    it "should move the schedulings of other team to team" do
      create :scheduling, team: team
      create :scheduling, team: other_team
      new_team = team
      expect { merge(team, other_team, new_team) }.to change(team.schedulings, :count).by(1)
    end
  end
end
