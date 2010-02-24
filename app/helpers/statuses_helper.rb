module StatusesHelper  
  def statuses_for(day, statuses)
    statuses.select { |status| status.day == day }
  end
end
