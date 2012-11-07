jQuery(document).ready ->
  $('input#employee_first_name,input#employee_last_name').keyup ->
    first_name = $('input#employee_first_name').val()
    last_name = $('input#employee_last_name').val()
    url = $('form#new_employee').data('search-url')
    delay (->
      search(url, first_name: first_name, last_name: last_name)
      ), 500

  search = (search_url, params = {}) ->
    $.ajax
      url: search_url
      data:
        query: params

  delay = (->
    timer = 0
    (callback, ms) ->
      clearTimeout timer
      timer = setTimeout(callback, ms)
  )()
