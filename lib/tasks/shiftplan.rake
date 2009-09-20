namespace :db do
  namespace :seed do
    task :default => :all

    desc 'Seed all'
    task :all do
      Rake::Task['db:seed:qualifications'].invoke
      Rake::Task['db:seed:employees'].invoke
      Rake::Task['db:seed:workplaces'].invoke
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
        :color => '880000', :active => true, :requirements => kitchen_requirements
      )
      Workplace.create!(
        :name => 'Bar', :qualification_list => 'Barkeeper', :default_shift_length => 600,
        :color => '008800', :active => true, :requirements => bar_requirements
      )
      Workplace.create!(
        :name => 'Rezeption', :qualification_list => 'Rezeptionist', :default_shift_length => 480,
        :color => '000088', :active => false, :requirements => reception_requirements
      )
    end
  end
end