jQuery(document).ready ->
  # TODO: Filtering for new employee form deactivated for now. We want something else
  # here.
  # $('input#employee_first_name,input#employee_last_name').keyup ->
  #   first_name = $('input#employee_first_name').val()
  #   last_name = $('input#employee_last_name').val()
  #   delay (->
  #     search(first_name: first_name, last_name: last_name)
  #     ), 500

  $('form#search input#first_name,form#search input#last_name').keyup ->
    first_name = $('form#search input#first_name').val()
    last_name = $('form#search input#last_name').val()
    delay (->
      search(first_name: first_name, last_name: last_name)
      ), 500

  search = (params = {}) ->
    $.ajax
      url: $('form#search').attr('action')
      data:
        query: params

  delay = (->
    timer = 0
    (callback, ms) ->
      clearTimeout timer
      timer = setTimeout(callback, ms)
  )()

  $('a#clear-search').click ->
    $('form#search input#first_name').val('')
    $('form#search input#last_name').val('')
    $('form#search input#first_name').trigger('keyup')
