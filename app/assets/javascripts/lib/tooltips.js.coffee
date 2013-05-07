jQuery(document).ready ->
  tipsify = ->
    $('[role="content"] [title]').tipsy
      delayIn: 500
      gravity: 's'
      opacity: '1'
      offset:  '5'  # prevent bouncing of hover state

  tipsify()
  $("#calendar").on 'update', tipsify
