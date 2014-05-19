# the ember-i18n-rails gem exports our locale/*yml files into
# `I18n.translations`. But the ember-i18n gem looks for them in
# `Ember.I18n.translations`

unless Ember
  console?.error "could not find Ember constant"

unless Ember.I18n
  console?.error "could not find Ember.I18n - is ember-i18n loaded?"

if Ember.I18n.translations.flash
  console?.error "there already seem to be some translations loaded in Ember.I18n.translations. Won't overwrite them."
else
  Ember.I18n.translations = I18n.translations
