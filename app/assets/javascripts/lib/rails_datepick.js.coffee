# Rails magic parses our submitted date. The user may have chosen a locale which
# makes the datepicker format dates in an ambigious way.
#
# Instead, we put the date iso8601-formatted into a hidden field and let rails
# parse that.
parseIso8601 = (str) ->
  return null unless str?
  $.datepick.parseDate('yyyy-mm-dd*', str)

addNamesToDatepickerSelects = (picker, inst) ->
  picker.find('select.datepick-month-year').each ->
    $s = $(this)
    $s.attr('name', $s.attr('title'))

$.fn.rails_datepick = ->
  $(this).each ->
    $stringy = $(this)

    $iso = $stringy
      .clone()
      .attr('type', 'hidden')
      .appendTo($stringy.parent())

    default_date = parseIso8601 $iso.val()

    $stringy
      .attr('readonly', 'readonly')
      .datepick
        onShow: $.datepick.multipleEvents(
          $.datepick.highlightWeek,
          addNamesToDatepickerSelects
        )
        onSelect: (dates) ->
          date = dates[0]
          $iso.val($.datepick.formatDate($.datepick.ISO_8601, date))
     .datepick('setDate', default_date)


