class Plan::Period < Struct.new(:starts_at, :ends_at) # is almost a Range
  # we have to deal with an open interval. As such, the predicates only return
  # `true` if and only if:
  # 1) a/at least one delimiter is set
  # 2) the given date violates it
  #
  # so, a `false` may mean `nil`

  def include?(date)
    (!starts_at || !_starts_after?(date)) &&
      (!ends_at || !_ends_before?(date))
  end

  def exclude?(date)
    starts_after?(date) || ends_before?(date)
  end

  def starts_after?(date)
    starts_at && _starts_after?(date)
  end

  def ends_before?(date)
    ends_at && _ends_before?(date)
  end

  private


  def _starts_after?(date)
    date.to_datetime < starts_at
  end

  def _ends_before?(date)
    ends_at < date.to_datetime
  end


end
