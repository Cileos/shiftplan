# Rails magic parses our submitted date. The user may have chosen a locale which
# makes the datepicker format dates in an ambigious way.
#
# Instead, we put the date iso8601-formatted into a hidden field and let rails
# parse that.
parseIso8601 = (str) ->
  return null unless str?
  $.datepick.parseDate('yyyy-mm-dd*', str)

default_options =
  onSelect: (dates)-> #nuffin

$.fn.rails_datepick = (options)->
  options = $.extend default_options, options
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
        onSelect: (dates) ->
          date = dates[0]
          $iso.val($.datepick.formatDate($.datepick.ISO_8601, date))
          options.onSelect.apply(this, arguments)
     .datepick('setDate', default_date)


