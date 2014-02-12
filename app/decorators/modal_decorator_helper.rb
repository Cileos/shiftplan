module ModalDecoratorHelper

  # Renders a modal box, must give at least :body
  # title must be given as title and will be added to the dialog source element (see http://jqueryui.com/demos/dialog/#option-title)
  def modal(options = {})
    body = options.delete(:body) || raise(ArgumentError, 'no :body given for modal')
    raise(ArgumentError, 'blank body given for modal') if body.blank?
    h.content_tag :div, body, options.merge(id: 'modalbox')
  end

  # removes all modal boxes first, appends a new one to the body and opens it
  # title can be given as :header or :title
  def append_modal(options = {})
    remove_modal
    dialog_options = {
      title: options.delete(:header)
    }
    page.select('body').append(modal(options))
    select(:modal).dialog( options.reverse_merge(modal_default_options).merge(dialog_options) )
  end

  def append_modal_with_form(options = {})
    action = options.fetch(:action) do
      !source.respond_to?(:new_record?) || source.new_record? ? 'new' : 'edit'
    end
    form_options = {
      body: h.render('form', resource_name.to_sym => self),
      header: h.ta(".#{action}_#{resource_name}")
    }
    append_modal(options.reverse_merge(form_options))
  end

  # see http://jqueryui.com/demos/dialog/#modal
  def modal_default_options
    {
      modal: true,
      resizable: false,
      draggable: true,
      zIndex: 500, # bootstrap typeahead
      width: 'auto'
    }
  end

  def append_to_modal(html)
    select(:modal).append html
  end

  def prepend_to_modal(html)
    select(:modal).prepend html
  end

  def hide_modal(*a)
    if a.empty?
      page.select('#modalbox')
    else
      select(*a)
    end.dialog('close')
  end

  def clear_modal
    hide_modal
    select(:modal).html ''
  end

  def remove_modal
    hide_modal
    select(:modal).remove()
  end

  def selector_for(name, *more)
    case name
    when :modal
      '#modalbox'
    else
      super
    end
  end

end
