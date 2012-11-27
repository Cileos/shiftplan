jQuery(document).ready ->

  $('form#search').each ->
    $search_form = $(this)
    search_url = $search_form.attr('action')

    $search_form.find('input').keyup ->
      search()

    $search_form.find('select').change ->
      search()

    search = ->
      query_params =
        query:
          first_name:   $search_form.find('input#first_name').val()
          last_name:    $search_form.find('input#last_name').val()
          email:        $search_form.find('input#email').val()
          organization: $search_form.find('select#organization').val()
      delay (->
        $.ajax
          url:  search_url
          data: query_params
        ), 500

    $('a#clear-search').click ->
      $('form#search').find('input[type=text],select').val('')
      $('form#search input#first_name').trigger('keyup')


  delay = (->
    timer = 0
    (callback, ms) ->
      clearTimeout timer
      timer = setTimeout(callback, ms)
  )()

