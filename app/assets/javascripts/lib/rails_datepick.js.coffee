# Rails magic parses our submitted date. The user may have chosen a locale which
# makes the datepicker format dates in an ambigious way.
#
# Instead, we put the date iso8601-formatted into a hidden field and let rails
# parse that.
parseIso8601 = (str) ->
  return null unless str?
  $.datepick.parseDate('yyyy-mm-dd*', str)

formatIso8601 = (date)->
  $.datepick.formatDate($.datepick.ISO_8601, date)

default_options =
  onSelect: (dates)-> #nuffin
  week: false  # indented to select a week instead of an exact date
  prepend: false # the content of the original input should be submitted, not the hidden field

$.fn.rails_datepick = (options)->
  $(this).each ->
    o = $.extend {}, default_options, options
    $stringy = $(this)

    $iso = $stringy
      .clone()
      .attr('type', 'hidden')

    if o.prepend
      $iso.prependTo($stringy.parent())
    else
      $iso.appendTo($stringy.parent())

    default_date = parseIso8601 $stringy.data('iso-date')

    onSelect = o.onSelect
    o.onSelect = (dates)->
      date = dates[0]
      $iso.val(formatIso8601(date))
      onSelect.apply(this, arguments)

    if o.week
      o.renderer = $.extend {}, $.datepick.weekOfYearRenderer,
        picker: $.datepick.weekOfYearRenderer.picker.
          # hide "clear"
          replace(/\{link:clear\}/, ''),

    $stringy
      .attr('readonly', 'readonly')
      .datepick(o)
      .datepick('setDate', default_date)

$.rails_datepick = {}
$.rails_datepick.parse = parseIso8601
$.rails_datepick.format = formatIso8601
