Sham.employee_id(:unique => false) { 1 }
Sham.password do
  chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
  password = ''
  8.times { password << chars.rand }
  password
end

Status.blueprint do
  employee_id
  status { Status::VALID_STATUSES.first }
end

Employee.blueprint do
  first_name { Faker::Name.first_name }
  last_name  { Faker::Name.last_name }
end

Qualification.blueprint do
  name { %w(Barkeeper Cook Receptionist).rand }
end

Workplace.blueprint do
  name { %w(Bar Kitchen Reception).rand }
end

Plan.blueprint do
  start_date { Date.tomorrow }
  end_date   { 8.days.from_now.to_date }
  start_time { Date.tomorrow.beginning_of_day }
  end_time   { 8.days.from_now.end_of_day }
end

Assignment.blueprint do
end

Shift.blueprint do
  start { Time.current }
  self.end { 8.hours.from_now }
end

WorkplaceRequirement.blueprint do
end

WorkplaceQualification.blueprint do
end

User.blueprint do
  email { Faker::Internet.email }
  password
end
