#= require lib
#= require clockwork
#= require ember-qunit
#= require_self
#= require_tree .

emq.globalize()
setResolver Ember.DefaultResolver.create(namespace: Clockwork)
