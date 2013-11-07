jQuery(document).ready ->
  $indicator = $('#browser-width-detection')
  browser_width = parseInt($indicator.css('max-width'))

  if browser_width <= 525 || (browser_width <= 625 && $indicator.css('content') == 'landscape')
    $("#calendar").stickyTableHeaders fixedOffset: 0
  else
    $("#calendar").stickyTableHeaders fixedOffset: 50
