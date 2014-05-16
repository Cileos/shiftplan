#= require views/fields/single_select

Clockwork.Fields.SelectReason = Ember.Select.extend
  promptTranslation: "activerecord.values.unavailability.reasons._prompt"
  content: (->
    reasons = Ember.A()
    try
      for key,value of Ember.I18n.translations.activerecord.values.unavailability.reasons
        if key != '_prompt'
          reasons.pushObject { sym: key, text: value }
    catch error
      console?.error 'cannot build up reasons:', error
    reasons
  ).property()
  optionValuePath: 'content.sym'
  optionLabelPath: 'content.text'
