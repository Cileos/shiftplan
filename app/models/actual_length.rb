module ActualLength

  def actual_length_as_time
    Volksplaner::Formatter.numeric_hours_to_time_string(actual_length_in_hours)
  end

  def actual_length_as_time=(stringy_time)
    self.actual_length_in_hours = Volksplaner::Formatter.time_string_to_numeric_hours(stringy_time)
  end

end
