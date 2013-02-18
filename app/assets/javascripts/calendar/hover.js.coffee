jQuery(document).ready ->
  return if $('#calendar').length == 0

  # .hover here and toggleClass would interact with keyboard driven .focus,
  # so we are pretty explicit here
  $('.scheduling[data-pairing]').mouseenter ->
    $('#calendar').find('[data-pairing=' + $(this).attr('data-pairing') + ']').addClass('focus')
  $('.scheduling[data-pairing]').mouseleave ->
    $('#calendar').find('[data-pairing=' + $(this).attr('data-pairing') + ']').removeClass('focus')
