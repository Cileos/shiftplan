class DuplicateEmployeeValidator < ActiveModel::Validator
  def validate(record)
    unless record.force_create_duplicate == "1"
      record.duplicates = EmployeeSearch.new(
        first_name: record.first_name,
        last_name: record.last_name,
        base: record.account.employees
      ).results
      unless record.duplicates.empty?
        record.errors[:base] << I18n.t('activerecord.errors.models.employee.duplicates_found')
      end
    end
  end
end
