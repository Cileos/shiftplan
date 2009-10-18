namespace :db do
  namespace :seed do
    task :default => :all

    desc 'Seed all'
    task :all do
      Rake::Task['db:seed:plans'].invoke
      Rake::Task['db:seed:locations'].invoke
      Rake::Task['db:seed:qualifications'].invoke
      Rake::Task['db:seed:employees'].invoke
      Rake::Task['db:seed:workplaces'].invoke
      Rake::Task['db:seed:shifts'].invoke
    end

    desc 'Seed locations'
    task :locations => :environment do
      Location.delete_all

      Location.create!(:name => 'Zentrum 1')
      Location.create!(:name => 'Zentrum 2')
    end

    desc 'Seed plans'
    task :plans => :environment do
      Plan.delete_all

      monday_morning   = Time.parse('2009-09-07 08:00')
      friday_afternoon = Time.parse('2009-09-11 16:00')

      Plan.create!(:name => 'Plan 1', :start => monday_morning, :end => friday_afternoon)
    end

    desc 'Seed qualifications'
    task :qualifications => :environment do
      Qualification.delete_all

      Qualification.create!(:name => 'Koch')
      Qualification.create!(:name => 'Küchenhilfe')
      Qualification.create!(:name => 'Barkeeper')
      Qualification.create!(:name => 'Rezeptionist')
    end

    desc 'Seed employees'
    task :employees => :environment do
      Employee.delete_all

      cook              = Qualification.find_by_name('Koch')
      cooking_assistant = Qualification.find_by_name('Küchenhilfe')
      barkeeper         = Qualification.find_by_name('Barkeeper')
      receptionist      = Qualification.find_by_name('Rezeptionist')

      Employee.create!(:first_name => 'Fritz', :last_name => 'Thielemann', :active => true, :qualifications => [cooking_assistant, barkeeper])
      Employee.create!(:first_name => 'Sven', :last_name => 'Fuchs', :active => false, :email => 'svenfuchs@artweb-design.de', :qualifications => [cook])
      Employee.create!(
        :first_name => 'Clemens', :last_name => 'Kofler', :email => 'clemens@railway.at',
        :birthday => Date.civil(1986, 5, 21), :active => true,
        :street => 'Czarnikauer Str 6A', :zipcode => '10439', :city => 'Berlin',
        :qualifications => [receptionist, barkeeper]
      )
    end

    desc 'Seed workplaces and workplace requirements'
    task :workplaces => :environment do
      Workplace.delete_all

      center_1 = Location.find_by_name('Zentrum 1')
      center_2 = Location.find_by_name('Zentrum 2')

      cook              = Qualification.find_by_name('Koch')
      cooking_assistant = Qualification.find_by_name('Küchenhilfe')
      barkeeper         = Qualification.find_by_name('Barkeeper')
      receptionist      = Qualification.find_by_name('Rezeptionist')

      # kitchen_requirements   = { cook.id => { :quantity => 1 }, cooking_assistant.id => { :quantity => 2 } }
      # bar_requirements       = { barkeeper.id => { :quantity => 2 } }
      # reception_requirements = { receptionist.id => { :quantity => 1 } }
      kitchen_requirements   = [{ :qualification_id => cook.id, :quantity => 1 }, { :qualification_id => cooking_assistant.id, :quantity => 2 }]
      bar_requirements       = [{ :qualification_id => barkeeper.id, :quantity => 2 }]
      reception_requirements = [{ :qualification_id => receptionist.id, :quantity => 1 }]

      # Workplace.create!(
      #   :location => center_1, :name => 'Küche', :qualifications => [cook, cooking_assistant],
      #   :default_shift_length => 480, :active => true, :requirements => kitchen_requirements
      # )
      # Workplace.create!(
      #   :location => center_1, :name => 'Bar', :qualifications => [barkeeper],
      #   :default_shift_length => 600, :active => true, :requirements => bar_requirements
      # )
      # Workplace.create!(
      #   :location => center_1, :name => 'Rezeption', :qualifications => [receptionist],
      #   :default_shift_length => 480, :active => false, :requirements => reception_requirements
      # )
      Workplace.create!(
        :location => center_1, :name => 'Küche', :qualifications => [cook, cooking_assistant],
        :default_shift_length => 480, :active => true, :workplace_requirements_attributes => kitchen_requirements
      )
      Workplace.create!(
        :location => center_1, :name => 'Bar', :qualifications => [barkeeper],
        :default_shift_length => 600, :active => true, :workplace_requirements_attributes => bar_requirements
      )
      Workplace.create!(
        :location => center_1, :name => 'Rezeption', :qualifications => [receptionist],
        :default_shift_length => 480, :active => false, :workplace_requirements_attributes => reception_requirements
      )
    end

    desc 'Seed shifts, requirements and assignments'
    task :shifts => :environment do
      Shift.delete_all

      monday_morning = Time.parse('2009-09-07 8:00')
      tuesday_morning = monday_morning + 1.day

      plan = Plan.find_by_name('Plan 1')

      kitchen   = Workplace.find_by_name('Küche')
      bar       = Workplace.find_by_name('Bar')
      reception = Workplace.find_by_name('Rezeption')

      # cook              = Qualification.find_by_name('Koch')
      # cooking_assistant = Qualification.find_by_name('Küchenhilfe')
      # barkeeper         = Qualification.find_by_name('Barkeeper')
      # receptionist      = Qualification.find_by_name('Rezeptionist')

      kitchen_shift_1 = Shift.create!(:plan => plan, :workplace => kitchen, :start => monday_morning, :end => monday_morning + 8.hours)
      kitchen_shift_2 = Shift.create!(:plan => plan, :workplace => kitchen, :start => tuesday_morning + 3.hours, :end => tuesday_morning + 11.hours)

      # bar_shift_1 = Shift.create!(:plan => plan, :workplace => bar, :start => monday + 9.hours, :end => monday + 12.hours)
      # bar_shift_2 = Shift.create!(:plan => plan, :workplace => bar, :start => monday + 12.hours, :end => monday + 16.hours)
      # 
      # kitchen_shift_3 = Shift.create!(:plan => plan, :workplace => kitchen, :start => tuesday + 7.hours, :end => tuesday + 11.hours)
      # kitchen_shift_4 = Shift.create!(:plan => plan, :workplace => kitchen, :start => tuesday + 11.hours, :end => tuesday + 15.hours)
      # 
      # bar_shift_3 = Shift.create!(:plan => plan, :workplace => bar, :start => tuesday + 9.hours, :end => tuesday + 12.hours)
      # bar_shift_4 = Shift.create!(:plan => plan, :workplace => bar, :start => tuesday + 12.hours, :end => tuesday + 16.hours)

      # reception_shift_1 = Shift.create!(:workplace => reception, :start => beginning_of_week + 6.hours, :end => beginning_of_week + 16.hours)
      # reception_shift_2 = Shift.create!(:workplace => reception, :start => beginning_of_week + 16.hours, :end => beginning_of_week + 26.hours)
      # 
      # reception_shift_3 = Shift.create!(:workplace => reception, :start => beginning_of_week + 1.day + 6.hours, :end => beginning_of_week + 1.day + 16.hours)
      # reception_shift_4 = Shift.create!(:workplace => reception, :start => beginning_of_week + 1.day + 16.hours, :end => beginning_of_week + 1.day + 26.hours)

      # implicitly created when shifts are created
      #
      # [kitchen_shift_1, kitchen_shift_2, kitchen_shift_3, kitchen_shift_4].each do |shift|
      #   shift.requirements.create(:qualification => cook)
      #   2.times { shift.requirements.create(:qualification => cooking_assistant) }
      # end
      # 
      # [bar_shift_1, bar_shift_2].each do |shift|
      #   shift.requirements.create(:qualification => barkeeper)
      # end
      # 
      # [bar_shift_3, bar_shift_4].each do |shift|
      #   2.times { shift.requirements.create(:qualification => barkeeper) }
      # end
      # 
      # [reception_shift_1, reception_shift_2, reception_shift_3, reception_shift_4].each do |shift|
      #   shift.requirements.create(:qualification => receptionist)
      # end

      # let's say the first bar shifts only need 1 barkeeper
      # bar_shift_1.requirements.last.destroy
      # bar_shift_3.requirements.last.destroy
    end
  end
end
