#= require grouping_table
#= require_tree ./ember-patches
#= require_self
#= require_tree ./mixins
#= require_tree ./properties
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./components
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes

Ember.LOG_BINDINGS = false
get = Ember.get

Clockwork = Ember.Application.create
  LOG_TRANSITIONS: true
  Fields: Ember.Object.extend()
  cursor: null
  page: null
  fnord: 1

Clockwork.ApplicationSerializer = DS.ActiveModelSerializer.extend
  attrs:
    accounts:
      embedded: 'ids'
  # When settings "embedded" to "ids", we will just send the ids of the
  # associated records within the JSON
  serializeHasMany: (record, json, relationship)->
    key = relationship.key
    attrs = get(this, 'attrs')
    embed = attrs && attrs[key]?.embedded is 'ids'

    if embed
      json[ @keyForRelationship(key, 'hasMany') ] = get(record, key).map (relation)=>
        primaryKey = get(this, 'primaryKey')
        get(relation, primaryKey)
    else
      @_super(record, json, relationship)


Clockwork.settings = Ember.Object.create
  dateFormat: 'yyyy-mm-dd' # TODO globalize
  timeoptions:
    show24Hours: true
    showSeconds: false
    spinnerImage: ''
    timeSteps: [1, 15, 0]
    useMouseWheel: true

# can be removed when we use Ember everywhere
Clockwork.initializer
  name: 'rootElement'
  initialize: (container)->
    # ember should only run on selected pages
    Clockwork.deferReadiness()

    if ($root = $('#milestones')).length > 0
      Clockwork.set 'rootElement', '#milestones'
      Clockwork.set 'page', 'milestones'
      # base all URLs on current plan

      Clockwork.set 'cursor', new CalendarCursor $('table#calendar')
      Clockwork.advanceReadiness()

    if ($root = $('#unavailabilities')).length > 0
      Clockwork.set 'rootElement', '#unavailabilities'
      Clockwork.set 'page', 'unavailabilities'
      Clockwork.advanceReadiness()

Clockwork.initializer
  name: 'RESTnamespace'
  initialize: (container)->
    if ($root = $('#milestones')).length > 0
      # base all URLs on current plan
      Clockwork.ApplicationAdapter = DS.ActiveModelAdapter.extend
        namespace: (window.location.pathname.replace(/(plans\/[^/]+).*$/,'$1')).slice(1)

    if ($root = $('#unavailabilities')).length > 0
      Clockwork.ApplicationAdapter = DS.ActiveModelAdapter.extend
        namespace: 'ember'


Clockwork.initializer
  # injects 'currentUser' in every controller for authorization
  name: 'currentUser'
  after: 'RESTnamespace'
  initialize: (container) ->
    if Clockwork.get('page')
      Clockwork.deferReadiness()
      store = container.lookup('store:main')
      user = store.find 'session', 'current'
      controller = container.lookup('controller:currentUser').set('content', user)
      container.typeInjection('controller', 'currentUser', 'controller:currentUser')
      user.then ->
        Clockwork.advanceReadiness()

Clockwork.initializer
  # injects 'employees' in every controller. Is loaded in Applicationroute
  name: 'employees'
  initialize: (container)->
    if Clockwork.get('page')
      # lookup once to warm up caches and avoid StackLevelTooDeep
      container.lookup('controller:employees')
      container.typeInjection('controller', 'employees', 'controller:employees')

Clockwork.initializer
  name: 'load-i18n'
  initialize: (container)->
    if Clockwork.get('page')
      Clockwork.deferReadiness()
      locale = $('html').attr('lang') || 'en'
      f = $.getJSON "/i18n/#{locale}.json"
      f.then (result)->
        Ember.I18n.translations = result
        Clockwork.advanceReadiness()


window.Clockwork = Clockwork
