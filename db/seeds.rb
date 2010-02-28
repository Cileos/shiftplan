if Account.first
  ActiveRecord::Base.send(:subclasses).each do |model|
    connection = model.connection
    if connection.instance_variable_get(:@config)[:adapter] == 'mysql'
      connection.execute("TRUNCATE #{model.table_name}") rescue nil
    else
      connection.execute("DELETE FROM #{model.table_name}") rescue nil
    end
  end
end

account = Account.create!(
  :name  => 'Cileos UG',
  :admin => {
    :email => 'fritz@thielemann.de',
    :password => 'oracle',
    :password_confirmation => 'oracle',
    :email_confirmed => true
  }
)

cook              = Qualification.create!(:account => account, :name => 'Koch')
cooking_assistant = Qualification.create!(:account => account, :name => 'Küchenhilfe')
barkeeper         = Qualification.create!(:account => account, :name => 'Barkeeper')
receptionist      = Qualification.create!(:account => account, :name => 'Rezeptionist')

Employee.create!(
  :account        => account,
  :first_name     => 'Fritz',
  :last_name      => 'Thielemann',
  :active         => true,
  :qualifications => [cooking_assistant, barkeeper]
)
Employee.create!(
  :account        => account,
  :first_name     => 'Sven',
  :last_name      => 'Fuchs',
  :active         => false,
  :email          => 'svenfuchs@artweb-design.de',
  :qualifications => [cook]
)
Employee.create!(
  :account        => account,
  :first_name     => 'Clemens',
  :last_name      => 'Kofler',
  :email          => 'clemens@railway.at',
  :birthday       => Date.civil(1986, 5, 21),
  :active         => true,
  :street         => 'Czarnikauer Str 6A',
  :zipcode        => '10439',
  :city           => 'Berlin',
  :qualifications => [receptionist, barkeeper]
)


kitchen = Workplace.create!(
  :account              => account,
  :name                 => 'Küche',
  :qualifications       => [cook, cooking_assistant],
  :default_shift_length => 480,
  :active               => true
)

kitchen.workplace_requirements.create!(:quantity => 1, :qualification => cook)
kitchen.workplace_requirements.create!(:quantity => 2, :qualification => cooking_assistant)

bar = Workplace.create!(
  :account              => account,
  :name                 => 'Bar',
  :qualifications       => [barkeeper],
  :default_shift_length => 600,
  :active               => true
)

bar.workplace_requirements.create!(:quantity => 2, :qualification => barkeeper)

reception = Workplace.create!(
  :account              => account,
  :name                 => 'Rezeption',
  :qualifications       => [receptionist],
  :default_shift_length => 480,
  :active               => false
)
reception.workplace_requirements.create!(:quantity => 1, :qualification => receptionist)

monday_morning   = Time.local(2009, 9,  7,  8, 0)
tuesday_morning  = Time.local(2009, 9,  8,  8, 0)
friday_afternoon = Time.local(2009, 9, 11, 22, 0)

plan_1 = Plan.create!(
  :account => account,
  :name    => 'Plan 1',
  :start_date => monday_morning.to_date,
  :end_date   => friday_afternoon.to_date,
  :start_time => monday_morning.to_time,
  :end_time   => friday_afternoon.to_time
)
plan_1.shifts.create!(
  :workplace => kitchen,
  :start     => monday_morning,
  :end       => monday_morning + 8.hours
)
plan_1.shifts.create!(
  :workplace => kitchen,
  :start     => tuesday_morning + 3.hours,
  :end       => tuesday_morning + 11.hours
)
