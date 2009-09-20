namespace :db do
  namespace :seed do
    task :default => :all

    desc 'Seed all'
    task :all do
      Rake::Task['db:seed:qualifications'].invoke
      Rake::Task['db:seed:employees'].invoke
      Rake::Task['db:seed:workplaces'].invoke
      Rake::Task['db:seed:shifts'].invoke
    end

    desc 'Seed qualifications'
    task :qualifications => :environment do
      Tag.create!(:name => 'Koch')
      Tag.create!(:name => 'Küchenhilfe')
      Tag.create!(:name => 'Barkeeper')
      Tag.create!(:name => 'Rezeptionist')
    end

    desc 'Seed employees'
    task :employees => :environment do
      Employee.create!(:first_name => 'Fritz', :last_name => 'Thielemann', :active => true, :qualification_list => 'Küchenhilfe, Barkeeper')
      Employee.create!(:first_name => 'Sven', :last_name => 'Fuchs', :active => false, :email => 'svenfuchs@artweb-design.de', :qualification_list => 'Koch')
      Employee.create!(
        :first_name => 'Clemens', :last_name => 'Kofler', :email => 'clemens@railway.at',
        :birthday => Date.civil(1986, 5, 21), :active => true,
        :street => 'Czarnikauer Str 6A', :zipcode => '10439', :city => 'Berlin',
        :qualification_list => 'Rezeptionist, Barkeeper'
      )
    end

    desc 'Seed workplaces and workplace requirements'
    task :workplaces => :environment do
      cook              = Tag.find_by_name('Koch')
      cooking_assistant = Tag.find_by_name('Küchenhilfe')
      barkeeper         = Tag.find_by_name('Barkeeper')
      receptionist      = Tag.find_by_name('Rezeptionist')

      kitchen_requirements   = { cook.id => { :quantity => 1 }, cooking_assistant.id => { :quantity => 2 } }
      bar_requirements       = { barkeeper.id => { :quantity => 2 } }
      reception_requirements = { receptionist.id => { :quantity => 1 } }

      Workplace.create!(
        :name => 'Küche', :qualification_list => 'Koch, Küchenhilfe', :default_shift_length => 480,
        :color => 'ff8c8c', :active => true, :requirements => kitchen_requirements
      )
      Workplace.create!(
        :name => 'Bar', :qualification_list => 'Barkeeper', :default_shift_length => 600,
        :color => 'ffc68c', :active => true, :requirements => bar_requirements
      )
      Workplace.create!(
        :name => 'Rezeption', :qualification_list => 'Rezeptionist', :default_shift_length => 480,
        :color => 'ffff8c', :active => false, :requirements => reception_requirements
      )
    end

    desc 'Seed shifts, requirements and assignments'
    task :shifts => :environment do
      beginning_of_week = Date.today.beginning_of_week

      kitchen   = Workplace.find_by_name('Küche')
      bar       = Workplace.find_by_name('Bar')
      reception = Workplace.find_by_name('Rezeption')

      cook              = Tag.find_by_name('Koch')
      cooking_assistant = Tag.find_by_name('Küchenhilfe')
      barkeeper         = Tag.find_by_name('Barkeeper')
      receptionist      = Tag.find_by_name('Rezeptionist')

      kitchen_shift_1 = Shift.create!(:workplace => kitchen, :start => beginning_of_week + 7.hours, :end => beginning_of_week + 13.hours)
      kitchen_shift_2 = Shift.create!(:workplace => kitchen, :start => beginning_of_week + 16.hours, :end => beginning_of_week + 22.hours)

      kitchen_shift_3 = Shift.create!(:workplace => kitchen, :start => beginning_of_week + 1.day + 7.hours, :end => beginning_of_week + 1.day + 13.hours)
      kitchen_shift_4 = Shift.create!(:workplace => kitchen, :start => beginning_of_week + 1.day + 16.hours, :end => beginning_of_week + 1.day + 22.hours)

      bar_shift_1 = Shift.create!(:workplace => bar, :start => beginning_of_week + 8.hours, :end => beginning_of_week + 17.hours)
      bar_shift_2 = Shift.create!(:workplace => bar, :start => beginning_of_week + 17.hours, :end => beginning_of_week + 26.hours)

      bar_shift_3 = Shift.create!(:workplace => bar, :start => beginning_of_week + 1.day + 8.hours, :end => beginning_of_week + 1.day + 17.hours)
      bar_shift_4 = Shift.create!(:workplace => bar, :start => beginning_of_week + 1.day + 17.hours, :end => beginning_of_week + 1.day + 26.hours)

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
      bar_shift_1.requirements.last.destroy
      bar_shift_3.requirements.last.destroy
    end
  end
end
