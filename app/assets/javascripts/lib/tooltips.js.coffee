jQuery(document).ready ->
  tipsify = ->
    $("[title]").tipsy
      delayIn: 500
      gravity: 's'
      opacity: '1'
      offset:  '5'  # prevent bouncing of hover state

  tipsify()
  $("#calendar").on 'update', tipsify
