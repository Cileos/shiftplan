require 'spec_helper'

describe ApplyPlanTemplate do
  let(:plan_template) { create(:plan_template) }
  let(:plan)          { create(:plan, organization: plan_template.organization) }
  let(:cook)          { create(:qualification) }
  let(:dishwasher)    { create(:qualification) }
  let(:kitchen)       { create(:team) }
  let(:restaurant)    { create(:team) }
  let!(:apply_plan_template) do
    ApplyPlanTemplate.new(
      plan:             plan,
      plan_template_id: plan_template.id,
      target_year:      2012,
      target_week:      49
    )
  end

  context "when saved" do
    # For year 2012 and week 49, the monday is 03.12.2012.
    let(:monday_schedulings) do
      schedulings_for_year_and_month.select do |s|
        s.starts_at.day == 3
      end
    end
    let(:schedulings_for_year_and_week) do
      plan.filter(cwyear: 2012, week: 49).unsorted_records # just a relation
    end
    let(:schedulings_for_year_and_month) do
      schedulings_for_year_and_week.select do |s|
        s.starts_at.year == 2012 && s.starts_at.month == 12
      end
    end

    context "without overnight shifts" do
      # day = 0 => monday
      let!(:monday_shift) do
        create(:shift, start_hour: 8, start_minute: 15, end_hour: 16, end_minute: 45, day: 0,
          plan_template: plan_template,
          team: kitchen,
          demands_attributes: [
            { quantity: 1, qualification_id: cook.id },
            { quantity: 2, qualification_id: dishwasher.id }
          ]
        )
      end
      # day = 4 => friday
      let!(:friday_shift) do
        create(:shift, start_hour: 10, start_minute: 15, end_hour: 18, end_minute: 45, day: 4,
          plan_template: plan_template,
          team: restaurant,
          demands_attributes: [
            { quantity: 2, qualification_id: cook.id },
            { quantity: 4, qualification_id: dishwasher.id }
          ]
        )
      end
      # For year 2012 and week 49, the friday is 07.12.2012.
      let(:friday_schedulings) do
        schedulings_for_year_and_month.select do |s|
          s.starts_at.day == 7
        end
      end

      it "creates 9 schedulings for the plan for year and week" do
        lambda {
          apply_plan_template.save
        }.should change(schedulings_for_year_and_week, :count).from(0).to(9)
      end

      it "remembers all created_schedulings (for undo)" do
        apply_plan_template.save
        apply_plan_template.created_schedulings.should have(9).records
        apply_plan_template.created_schedulings.each do |s|
          s.should be_a(Scheduling)
        end
        apply_plan_template.created_schedulings.map(&:id).uniq.should have(9).items
      end

      it "creates 3 schedulings on monday" do
        apply_plan_template.save

        monday_schedulings.count.should == 3
      end
      it "creates 6 schedulings on friday" do
        apply_plan_template.save

        friday_schedulings.count.should == 6
      end
      context "created schedulings on monday" do
        it "have the same start time as the monday shift" do
          apply_plan_template.save

          monday_schedulings.each do |s|
            s.starts_at.hour.should == 8
            s.starts_at.min.should  == 15
          end
        end
        it "have the same end time as the monday shift" do
          apply_plan_template.save

          monday_schedulings.each do |s|
            s.ends_at.hour.should == 16
            s.ends_at.min.should  == 45
          end
        end
        it "have the same team as the monday shift" do
          apply_plan_template.save

          monday_schedulings.each do |s|
            s.team == kitchen
          end
        end
        it "include one scheduling for a cook" do
          apply_plan_template.save

          monday_schedulings.select do |s|
            s.qualification == cook
          end.count.should == 1
        end
        it "include 2 schedulings for a dishwasher" do
          apply_plan_template.save

          monday_schedulings.select do |s|
            s.qualification == dishwasher
          end.count.should == 2
        end
      end
      context "schedulings on friday" do
        it "have the same start time as the friday shift" do
          apply_plan_template.save

          friday_schedulings.each do |s|
            s.starts_at.hour.should == 10
            s.starts_at.min.should  == 15
          end
        end
        it "have the same end time as the friday shift" do
          apply_plan_template.save

          friday_schedulings.each do |s|
            s.ends_at.hour.should == 18
            s.ends_at.min.should  == 45
          end
        end
        it "have the same team as the friday shift" do
          apply_plan_template.save

          friday_schedulings.each do |s|
            s.team == restaurant
          end
        end
        it "include 2 schedulings for a cook" do
          apply_plan_template.save

          friday_schedulings.select do |s|
            s.qualification == cook
          end.count.should == 2
        end
        it "include 4 schedulings for a dishwasher" do
          apply_plan_template.save

          friday_schedulings.select do |s|
            s.qualification == dishwasher
          end.count.should == 4
        end
      end
    end
    context "with overnight shift" do
      # day = 0 => monday
      let!(:overnight_shift) do
        create(:shift, start_hour: 22, start_minute: 15, end_hour: 6, end_minute: 45, day: 0,
          plan_template: plan_template,
          team: kitchen,
          demands_attributes: [
            { quantity: 2, qualification_id: cook.id }
          ]
        )
      end

      it "creates 4 schedulings for the plan for year and week" do
        lambda {
          apply_plan_template.save
        }.should change(schedulings_for_year_and_week, :count).from(0).to(4)
      end

      it "links the schedulings to their next day" do
        apply_plan_template.save

        monday_schedulings.each do |s|
          s.next_day.should_not be_nil
        end
      end
    end
    context "with shift without demands" do
      # day = 0 => monday
      let!(:overnight_shift) do
        create(:shift, start_hour: 9, start_minute: 15, end_hour: 18, end_minute: 45, day: 0,
          plan_template: plan_template,
          team: kitchen
        )
      end

      it "creates 1 scheduling for the plan for year and week" do
        lambda {
          apply_plan_template.save
        }.should change(schedulings_for_year_and_week, :count).from(0).to(1)
      end
    end
  end

end
