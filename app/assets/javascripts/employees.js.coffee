jQuery(document).ready ->

  $('form#search').each ->
    $search_form = $(this)
    search_url = $search_form.attr('action')

    search = ->
      query_params =
        query:
          first_name:   $search_form.find('input#first_name').val()
          last_name:    $search_form.find('input#last_name').val()
          email:        $search_form.find('input#email').val()
          organization: $search_form.find('select#organization').val()
      $.ajax
        url:  search_url
        data: query_params

    $search_form.find('input').bindWithDelay('keyup', search, 300)
    $search_form.find('select').bind('change', search)


    $('a#clear-search').click ->
      $('form#search').find('input[type=text],select').val('')
      $('form#search input#first_name').trigger('keyup')
