Sham.password do
  chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
  password = ''
  8.times { password << chars.rand }
  password
end

Sham.plan_name do |index|
  "Plan #{index}"
end

Account.blueprint do
  name { Faker::Name.name }
end

Status.blueprint do
  employee   { Employee.make }
  status     { Status::VALID_STATUSES.first }
  start_time { Time.zone.now }
  end_time   { 8.hours.from_now }
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
  name       { Sham.plan_name }
  account
  start_date { Date.today }
  end_date   { 8.days.from_now.to_date }
  start_time { Time.zone.parse('08:00:00') }
  end_time   { Time.zone.parse('18:00:00') }
end

Assignment.blueprint do
  assignee
  requirement
end

Shift.blueprint do
  plan
  workplace
  start    { Time.zone.now }
  self.end { 8.hours.from_now }
end

WorkplaceRequirement.blueprint do
  workplace
  qualification
end

WorkplaceQualification.blueprint do
  workplace
  qualification
end

User.blueprint do
  name  { Faker::Name.name }
  email { Faker::Internet.email }
  password
end

Membership.blueprint do
end

EmployeeQualification.blueprint do
  employee
  qualification
end

Requirement.blueprint do
  shift
  qualification
end
