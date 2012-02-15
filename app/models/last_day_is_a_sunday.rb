class LastDayIsASunday < ActiveModel::Validator
  def validate(record)
    unless record.last_day.to_date.cwday == 7
      record.errors[:last_day] = :not_sunday
    end
  end
end

