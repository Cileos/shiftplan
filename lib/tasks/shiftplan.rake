namespace :db do
  namespace :seed do
    task :default => :all

    desc 'Seed all'
    task :all do
      Rake::Task['db:seed:employees'].invoke
      Rake::Task['db:seed:workplaces'].invoke
    end

    desc 'Seed employees'
    task :employees => :environment do
      Employee.create!(:first_name => 'Fritz', :last_name => 'Thielemann', :active => true)
      Employee.create!(:first_name => 'Sven', :last_name => 'Fuchs', :active => false, :email => 'svenfuchs@artweb-design.de')
      Employee.create!(
        :first_name => 'Clemens',
        :last_name  => 'Kofler',
        :birthday   => Date.civil(1986, 5, 21),
        :active     => true,
        :email      => 'clemens@railway.at',
        :street     => 'Czarnikauer Str 6A',
        :zipcode    => '10439',
        :city       => 'Berlin'
      )
    end

    desc 'Seed workplaces and workplace requirements'
    task :workplaces => :environment do
      cook              = Tag.create!(:name => 'Koch')
      cooking_assistant = Tag.create!(:name => 'Küchenhilfe')
      barkeeper         = Tag.create!(:name => 'Barkeeper')
      receptionist      = Tag.create!(:name => 'Rezeptionist')

      kitchen_requirements   = { cook.id => { :quantity => 1 }, cooking_assistant.id => { :quantity => 2 } }
      bar_requirements       = { barkeeper.id => { :quantity => 2 } }
      reception_requirements = { receptionist.id => { :quantity => 1 } }

      Workplace.create!(
        :name => 'Küche', :qualification_list => 'Koch, Küchenhilfe',
        :color => '880000', :active => true, :requirements => kitchen_requirements
      )
      Workplace.create!(
        :name => 'Bar', :qualification_list => 'Barkeeper',
        :color => '008800', :active => true, :requirements => bar_requirements
      )
      Workplace.create!(
        :name => 'Rezeption', :qualification_list => 'Rezeptionist',
        :color => '000088', :active => false, :requirements => reception_requirements
      )
    end
  end
end