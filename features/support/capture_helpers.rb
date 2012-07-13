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
end
World(StringCaptureHelper)
include StringCaptureHelper
