jQuery(document).ready ->
  return if $('#page #calendar.hours-in-week').length == 0

  # $('#page').addClass('detail_condensed')

  $('#calendar td.day .scheduling').each ->
    stack = $(this).attr('data-stack')
    total = $(this).attr('data-total')

    entry_width = 100 / total

    # if $(this).attr('data-remaining') == "0"
    #     $(this).css('width', entry_width + '%')
    #            .css('right', '0')
    #            .css('z-index', 1000)
    # else
    $(this).css('width', entry_width + '%')
           .css('left', stack * entry_width + '%')
           .css('z-index', 1000 - total + stack)
