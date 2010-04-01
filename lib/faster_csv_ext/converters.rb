FasterCSV::Converters.merge!(
  # convert everything that looks like a boolean
  :boolean => lambda do |field|
    if field =~ /^(true|false)$/i
      $1.downcase == 'true' ? 1 : 0
    else
      field
    end
  end,
  # let's have this instead of hacking the default DateMatcher
  :german_date => lambda { |field| field =~ /^\d{1,2}\.\d{1,2}\.\d{4}$/ ? Date.parse(field) : field },
  # override default :all to include :date and :boolean converters
  :all => [:date, :german_date, :date_time, :numeric, :boolean]
)
