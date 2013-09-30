jQuery(document).ready ->
  $('body').on 'tick', ->
    $.getScript('/notifications')

 setInterval ->
   $('body').trigger 'tick'
 , 60 * 1000
