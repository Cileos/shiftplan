if Account.first
  ActiveRecord::Base.send(:subclasses).each do |model|
    connection = model.connection
    if connection.instance_variable_get(:@config)[:adapter] == 'mysql'
      connection.execute("TRUNCATE #{model.table_name}")
    else
      connection.execute("DELETE FROM #{model.table_name}")
    end
  end
end

account = Account.create!(
  :name  => 'Awesome Hostels Inc.',
  :admin => {
    :email => 'boss@awesome-hostels.com',
    :password => 'boss',
    :password_confirmation => 'boss',
    :email_confirmed => true
  }
)

# center_1 = Location.create!(:name => 'Zentrum 1')
# center_2 = Location.create!(:name => 'Zentrum 2')

cook              = Qualification.create!(:name => 'Koch')
cooking_assistant = Qualification.create!(:name => 'Küchenhilfe')
barkeeper         = Qualification.create!(:name => 'Barkeeper')
receptionist      = Qualification.create!(:name => 'Rezeptionist')

Employee.create!(
  :first_name     => 'Fritz',
  :last_name      => 'Thielemann',
  :active         => true,
  :qualifications => [cooking_assistant, barkeeper]
)
Employee.create!(
  :first_name     => 'Sven',
  :last_name      => 'Fuchs',
  :active         => false,
  :email          => 'svenfuchs@artweb-design.de',
  :qualifications => [cook]
)
Employee.create!(
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
  # :location             => center_1,
  :name                 => 'Küche',
  :qualifications       => [cook, cooking_assistant],
  :default_shift_length => 480,
  :active               => true,
  :workplace_requirements_attributes => [
    { :qualification_id => cook.id, :quantity => 1 },
    { :qualification_id => cooking_assistant.id, :quantity => 2 }
  ]
)
bar = Workplace.create!(
  :account              => account,
  # :location             => center_1,
  :name                 => 'Bar',
  :qualifications       => [barkeeper],
  :default_shift_length => 600,
  :active               => true,
  :workplace_requirements_attributes => [
    { :qualification_id => barkeeper.id, :quantity => 2 }
  ]
)
reception = Workplace.create!(
  :account              => account,
  # :location             => center_1,
  :name                 => 'Rezeption',
  :qualifications       => [receptionist],
  :default_shift_length => 480,
  :active               => false,
  :workplace_requirements_attributes => [
    { :qualification_id => receptionist.id, :quantity => 1 }
  ]
)

monday_morning   = Time.parse('2009-09-07 08:00')
tuesday_morning  = Time.parse('2009-09-08 08:00')
friday_afternoon = Time.parse('2009-09-11 16:00')

plan_1 = Plan.create!(
  :account => account,
  :name    => 'Plan 1',
  :start   => monday_morning,
  :end     => friday_afternoon
)
Shift.create!(
  :plan      => plan_1,
  :workplace => kitchen,
  :start     => monday_morning,
  :end       => monday_morning + 8.hours
)
Shift.create!(
  :plan      => plan_1,
  :workplace => kitchen,
  :start     => tuesday_morning + 3.hours,
  :end       => tuesday_morning + 11.hours
)
