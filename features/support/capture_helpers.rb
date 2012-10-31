Numerals = {
  'first'  => ':first',
  'second' => ':nth-of-type(2)',
  'third'  => ':nth-of-type(3)',
  'forth'  => ':nth-of-type(4)'
}
module StringCaptureHelper
  def capture_quoted
    /"([^"]+)"/
  end

  def capture_cell
    %r~(cell "[^"]+"/"[^"]+")~
  end

  def match_date_with_time(locale=:de)
    /\d{2}\.\d{2}.\d{4} um \d{2}:\d{2} Uhr/
  end

  def capture_date_with_time(*a)
    /(#{match_date_with_time(*a)})/
  end

  def match_nth
    /#{Numerals.keys.join('|')}/
  end

  def capture_nth
    /(#{match_nth})/
  end
end
World(StringCaptureHelper)
include StringCaptureHelper
