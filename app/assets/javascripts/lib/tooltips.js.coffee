jQuery(document).ready ->
  tipsify = ->
    $("[title]").tipsy
      delayIn: 500
      gravity: 's'

  tipsify()
  $("#calendar").on 'update', tipsify

