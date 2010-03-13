{
  :en => {
    :date => {
      :range => lambda { |key, values|
        start_date, end_date = values.values_at(:start, :end)
        raise ArgumentError.new('missing argument: start and end must be given') unless !!start_date && !!end_date

        start_format, end_format = if Date.same_month?(start_date, end_date)
          ['%B %d', '%d %Y']
        elsif Date.same_year?(start_date, end_date)
          ['%B %d', '%B %d %Y']
        else
          ['%B %d %Y', '%B %d %Y']
        end

        dates = [I18n.l(values[:start], :format => start_format), I18n.l(values[:end], :format => end_format)]
        dates.join(' - ').strip.gsub(/\s+/, ' ')
      }
    }
  }
}
