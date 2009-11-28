Sham.password do
  chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
  password = ''
  8.times { password << chars.rand }
  password
end

Account.blueprint do
  name { Faker::Name.name }
end

Status.blueprint do
  employee { Employee.make }
  status   { Status::VALID_STATUSES.first }
  start    { Time.current }
  self.end { 8.hours.from_now }
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
  account    { Account.make }
  start_date { Date.tomorrow }
  end_date   { 8.days.from_now.to_date }
  start_time { Date.tomorrow.beginning_of_day }
  end_time   { 8.days.from_now.end_of_day }
end

Assignment.blueprint do
  assignee    { Employee.make }
  requirement { Requirement.make }
end

Shift.blueprint do
  plan     { Plan.make }
  start    { Time.current }
  self.end { 8.hours.from_now }
end

WorkplaceRequirement.blueprint do
  workplace     { Workplace.make }
  qualification { Qualification.make }
end

WorkplaceQualification.blueprint do
  workplace     { Workplace.make }
  qualification { Qualification.make }
end

User.blueprint do
  email { Faker::Internet.email }
  password
end

Membership.blueprint do
end

Location.blueprint do
end

EmployeeQualification.blueprint do
  employee      { Employee.make }
  qualification { Qualification.make }
end

Requirement.blueprint do
  shift         { Shift.make }
  qualification { Qualification.make }
end
