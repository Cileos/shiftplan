#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require jquery.scrollTo-1.4.2
#= require space-pen/space-pen
#= require jquery.minicolors
#= require handlebars
#= require ember
#= require ember-data
#= require ember-rails-flash
#= require i18n/ember-i18n
# for QuickieParser
#= require xregexp
#= require xregexp/unicode-base
#= require xregexp/build
#= require moment-with-langs


#= require_tree './lib'
#= require bootstrap/dropdown
#= require spinner
#= require jquery.remotipart
#= require jquery.mailcheck.min
#= require fix_iOS_rotation
#= require StickyTableHeaders
#= require jquery.autosize
#= require jquery.cookie
#= require jquery.mousewheel
#= require jquery.timeentry
#= require datepicker/jquery.datepick
#= require datepicker/jquery.datepick.ext.js
#= require datepicker/jquery.datepick-de
#= require bindWithDelay/bindWithDelay
#= require chosen-jquery

Ember.Select.reopen(Ember.I18n.TranslateableProperties)
Ember.TextField.reopen(Ember.I18n.TranslateableAttributes)
Ember.TextArea.reopen(Ember.I18n.TranslateableAttributes)
