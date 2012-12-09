jQuery(document).ready ->
  tipsify = ->
    $("[title]").tipsy
      delayIn: 500
      gravity: 's'
      opacity: '1'

  tipsify()
  $("#calendar").on 'update', tipsify

