Sham.employee_id(:unique => false) { 1 }
Sham.status(:unique => false) { Status::VALID_STATUSES.first }

Status.blueprint do
  employee_id
  status
end
