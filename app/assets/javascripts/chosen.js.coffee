# TODO: I18n
chosen_default_texts =
  de:
    no_results_text: "Keine Ergebnisse gefunden"
    placeholder_text_single: "Wähle eine Option"
    placeholder_text_multiple: "Wähle einige Optionen"
  en:
    no_results_text: "No results match"
    placeholder_text_single: "Select an option"
    placeholder_text_multiple: "Select some options"


chosify = (opts)->
    $(".chosen-select").chosen(opts)
    # we need to set the overflow values when a modalbox has
    # chosen, otherwise the 'selects' are hidden
    $(".chosen-select").closest('.ui-dialog')
                       .addClass('has-chosen')

jQuery ->
  lang = $('html').attr('lang')
  chosen_opts =
    allow_single_deselect: true
    no_results_text: chosen_default_texts[lang]['no_results_text']
    placeholder_text_single: chosen_default_texts[lang]['placeholder_text_single']
    placeholder_text_multiple: chosen_default_texts[lang]['placeholder_text_multiple']

  chosify(chosen_opts)
# Nested Form's "add field" feature, adds fields dynamically to the form. (see
# shifts form)
# We bind to the Nested Form event 'nested:fieldAdded' to chosify just added
# select input fields.
  $(document).on "nested:fieldAdded", (event) ->
    inserted = event.field
    inserted.find('.chosen-select').chosen(chosen_opts)
  $("body").on "dialogopen", ->
    chosify(chosen_opts)

