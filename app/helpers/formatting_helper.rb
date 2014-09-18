module FormattingHelper
  def ago_with_date(timey)
    content_tag :span, time_ago_in_words(timey), title: l(timey)
  end
end
