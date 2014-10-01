# When providing fixtures in a script#fixtures tag as JSON, this helps to fill
# the given model with the contained data.
#
# load_fixtures_from_dom(MyApp, 'Post', 'posts')
window.load_fixtures_from_dom = (app, model_name, attr_name)->
  app.initializer
    name: "load_#{attr_name}"
    initialize: (container)->
      $("##{attr_name}_fixtures").each ->
        app[model_name].FIXTURES = $(this).data(attr_name)
