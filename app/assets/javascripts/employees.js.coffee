jQuery(document).ready ->

  $('form#new_employee').each ->
    $new_employee_form = $(this)

    $new_employee_form.find('input#employee_first_name,input#employee_last_name').keyup ->
      query_params =
        query:
          first_name: $new_employee_form.find('input#employee_first_name').val()
          last_name:  $new_employee_form.find('input#employee_last_name').val()
      if query_params['query']['first_name'].length > 0 and query_params['query']['last_name'].length > 0
        search_for_duplicates(query_params)

    search_for_duplicates = (query_params) ->
      delay (->
        $.ajax
          url:  $new_employee_form.data('duplicate-search-url')
          data: query_params
        ), 500

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

