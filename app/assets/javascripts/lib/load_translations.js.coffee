# fetches rails translations and includes them into the Ember environemnt
#
# Usage:   load_translations(YourAppConstant)
#
# Caveat: Your application must have an attribute 'page' not being null
window.load_translations = (app)->
  app.initializer
    name: 'load-i18n'
    initialize: (container)->
      if app.get('page')
        app.deferReadiness()
        locale = $('html').attr('lang') || 'en'
        f = $.getJSON "/i18n/#{locale}.json"
        f.then (result)->
          Ember.I18n.translations = result
          app.advanceReadiness()

