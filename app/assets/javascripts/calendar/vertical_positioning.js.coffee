jQuery(document).ready ->
  return if $('#page #calendar.hours-in-week').length == 0

  # $('#page').addClass('detail_condensed')

  $('#calendar td.day .scheduling').each ->
    stack = parseInt($(this).attr('data-stack'))
    total = parseInt($(this).attr('data-total'))

    entry_width = 100 / total

    $(this).css('width', 2*entry_width-4 + '%')
           .css('left', stack * entry_width + 2 + '%')
           .css('z-index', 100 - total + stack)
    if $(this).attr('data-remaining') == "0"
        $(this).css('width', entry_width-4 + '%')
