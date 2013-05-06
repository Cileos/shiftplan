# use factory except for the time range related attributes, so the
# validity of the Scheduling is not compromised
def build_without_dates(attrs={})
  build :scheduling, attrs.reverse_merge({
    starts_at: nil,
    ends_at:   nil,
    week:      nil,
    year:      nil,
    date:      nil
  })
end
