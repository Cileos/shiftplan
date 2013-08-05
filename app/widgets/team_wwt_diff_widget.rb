class TeamWwtDiffWidget < WwtDiffWidget
  def team
    row_record
  end

  # hours in this calendar (week)
  def hours
    @hours ||= records.select {|s| s.team == team }.sum(&:length_in_hours)
  end

  # hours in all plans of the same account in the week described y filter
  def all_hours
    @all_hours ||=
      filter.
      without(:plan).
      unsorted_records.
      where(team_id: team.id).
      to_a.
      sum(&:length_in_hours)
  end

  def wwt?
    false
  end

end
