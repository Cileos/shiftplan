# Attributes:
#   element: the jQuery element of a select field containing a subset of minutes
#
Clockwork.MinuteField = Ember.Object.extend
  init: ->
    @_super()
    $el = @get('element')
    $el.bind 'keydown', @pressed.bind(@)
    @$custom = $('<option />').appendTo($el)
    @reset()

  pressed: (event) ->
    code = event.which
    if 48 <= code <= 57
      event.preventDefault()
      num = code - 48
      @append(num)
      @get('element').trigger('change')
      false
    else
      true

  reset: ->
    @buf = ''

  val: (v) ->
    if v?
      @$custom.text(v).attr('value', v)
      @get('element').val(v)
      @buf = v
    else
      @buf

  append: (num) ->
    @buf += num
    if @buf.length > 2
      @buf = @buf.slice -2
    if @buf > 60
      @buf = @buf.slice -1
    @val(@buf)



