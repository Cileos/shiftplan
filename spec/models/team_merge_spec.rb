require 'spec_helper'

describe TeamMerge do
  let(:organization) { Factory :organization }

  describe 'between teams of same organization' do
    let(:team)       { Factory :team, organization: organization }
    let(:other_team) { Factory :team, organization: organization }

    def merge(t, ot)
      TeamMerge.new(team_id: t.id, other_team_id: ot.id).save
    end

    it "should delete other team" do
      team; other_team
      expect { merge(team, other_team) }.should change(Team, :count).by(-1)
      team.reload.should_not be_nil
    end

    it "should move the schedulings of other team to team" do
      Factory :scheduling, team: team
      Factory :scheduling, team: other_team
      expect { merge(team, other_team) }.should change(team.schedulings, :count).by(1)
    end
  end
end
