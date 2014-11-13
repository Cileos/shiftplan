describe FillPlanTemplate do
  let(:plan) { instance_double 'Plan', id: 23 }
  before :each do
    Plan.stub(:find).with(plan.id).and_return(plan)
  end
  let(:args) {{ plan_id: plan.id, year: 2012, week: 47 }}

  context '.new' do

    it 'can be filled through PlanTemplate like with accepts_nested_attributes_for' do
      tmpl = PlanTemplate.new filler_attributes: args
      tmpl.filler.plan_id.should == plan.id
      tmpl.filler.year.should == 2012
      tmpl.filler.week.should == 47
    end

  end

  context '#source_schedulings_count' do
    it 'asks filter for count' do
      cpt = described_class.new args
      Scheduling.stub filter: (filter = instance_double('SchedulingFilter'))
      filter.stub_chain(:unsorted_records, :where, :reorder, :count).and_return(7)
      cpt.source_schedulings_count.should == 7
    end

    it 'returns 0 when no plan set without even searching' do
      cpt = described_class.new args.merge(plan_id: nil)
      Scheduling.should_not_receive(:filter)
      cpt.source_schedulings_count.should == 0
    end

  end

  context '#fill!' do
    let(:plan) { create :plan }
    before :each do
      subject.template = template
      subject.plan_id = plan.id
      subject.week = 15
      subject.year = 2013
    end
    def schedule(attrs={})
      create(:manual_scheduling, attrs.reverse_merge(
        # DEFAULS
        year: 2013,
        week: 15,
        cwday: 1,
        quickie: '9-17',
        plan: plan,
        team: team
      ))
    end

    def assert_has_default_times(shift)
      shift.start_hour.should == 9
      shift.start_minute.should == 0
      shift.end_hour.should == 17
      shift.end_minute.should == 0
    end

    context 'from empty plan week' do
      it 'creates no shifts' do
        expect { subject.fill! }.not_to change { Shift.count }
      end
    end

    context 'from plan with one scheduling' do
      it 'creates one shift of it' do
        schedule
        expect { subject.fill! }.to change { Shift.count }.from(0).to(1)
        assert_has_default_times Shift.first
      end

      it 'skips the scheduling when it has no team (shifts need team)' do
        schedule team: nil
        expect { subject.fill! }.to_not change { Shift.count }.from(0)
      end

      it 'skips overnight scheduling from previous week' do
        schedule week: 14, cwday: 7, quickie: '22-6'
        expect { subject.fill! }.to_not change { Shift.count }.from(0)
      end
    end


    context 'from plan with two scheduling at different days' do
      it 'creates two shift of it' do
        schedule cwday: 2
        schedule cwday: 3
        expect { subject.fill! }.to change { Shift.count }.from(0).to(2)
        s1 = Shift.first
        assert_has_default_times s1
        s1.day.should == 1
        s2 = Shift.last
        assert_has_default_times s2
        s2.day.should == 2
      end
    end

    context 'from plan with two schedulings at same time' do
      context 'with same team' do
        context 'with same qualification' do
          before :each do
            schedule qualification: dancing
            schedule qualification: dancing
            schedule qualification: dancing
          end
          it 'groups them to one shift' do
            expect { subject.fill! }.to change { Shift.count }.from(0).to(1)
            s = Shift.first
            assert_has_default_times s
            s.day.should == 0
          end

          it 'creates only one demand, but specifies quantity' do
            expect { subject.fill! }.to change { Demand.count }.from(0).to(1)
            demand = Demand.first
            demand.qualification.should == dancing
            demand.quantity.should == 3
            demand.shift.should == Shift.first
          end
        end

        context 'with different qualifications' do
          before :each do
            schedule qualification: dancing
            schedule qualification: singing
            schedule qualification: hunting
          end
          it 'groups them to one shift with a demand per quali' do
            expect { subject.fill! }.to change { Shift.count }.from(0).to(1)
            Shift.all.each do |s|
              assert_has_default_times s
            end
          end

          it 'creates one demand per qualification' do
            expect { subject.fill! }.to change { Demand.count }.from(0).to(3)
            Demand.all.map(&:qualification).uniq.should have(3).records
            Demand.all.map(&:shift).uniq.should have(1).records
            Demand.all.each do |d|
              d.quantity.should == 1
            end
          end
        end
      end

      context 'with different teams' do
        it 'groups them to a shift per team' do
          schedule team: team
          schedule team: other_team
          expect { subject.fill! }.to change { Shift.count }.from(0).to(2)
        end
      end

    end

    let(:template) { create :plan_template }
    let(:team) { create :team, organization: template.organization }
    let(:other_team) { create :team, organization: template.organization }
    let(:filter) { instance_double 'SchedulingFilter', unsorted_records: Scheduling.all }

    # Qualifications
    let(:dancing) { create :qualification, name: "Dancing", account: template.account }
    let(:singing) { create :qualification, name: "Singing", account: template.account }
    let(:hunting) { create :qualification, name: "Hunting", account: template.account }
  end

end

