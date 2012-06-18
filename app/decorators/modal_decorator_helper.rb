module ModalDecoratorHelper

  # wraps the given block in modal divs. Must give at least :body
  def modal(options = {})
    body = options.delete(:body) || raise(ArgumentError, 'no :body given for modal')
    raise(ArgumentError, 'blank body given for modal') if body.blank?
    h.content_tag :div, body, options.merge(id: 'modalbox')
  end

  # removes all modal boxes first, appends a new one to the body and opens it
  def append_modal(options = {})
    hide_modal
    remove_modal
    page.select('body').append(modal(options))
    select(:modal).dialog( options.reverse_merge(modal_default_options) )
  end

  # see http://jqueryui.com/demos/dialog/#modal
  def modal_default_options
    {
      modal: true,
      resizable: true,
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
