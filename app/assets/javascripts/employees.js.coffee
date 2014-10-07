jQuery(document).ready ->

  $invitation_fields = -> $('form.employee div.invitation_fields')
  $invitation_inputs = -> $invitation_fields().find('input')

  $('input#employee_invite').each ->
    if $(this).is(':checked')
      $invitation_fields().show()
    else
      # Prevent submitting params for hidden invitation fields by disabling
      # them.
      $invitation_inputs().prop('disabled', true)

  $('input#employee_invite').on 'change', ->
    if $(this).is(':checked')
      $invitation_inputs().prop('disabled', false)
      $invitation_fields().show()
    else
      $invitation_fields().hide()
      $invitation_inputs().prop('disabled', true)

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


  $('body').on 'change', 'table#employees label.planable :input:checkbox', (e)->
    $box = $(this)
    checked = $box.is(':checked')
    url = $box.closest('label').data('url')
    console?.debug "planable", url, checked

    set = $.ajax
      url: url
      type: 'PATCH'
      data:
        employee:
          planable: checked

    set.fail ->
      $box.prop('checked', !checked) # revert old status
