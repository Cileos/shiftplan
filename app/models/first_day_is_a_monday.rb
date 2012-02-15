class FirstDayIsAMonday < ActiveModel::Validator
  def validate(record)
    unless record.first_day.to_date.cwday == 1
      record.errors[:first_day] = :not_monday
    end
  end
end
