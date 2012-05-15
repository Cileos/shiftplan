module ModalDecoratorHelper

  # wraps the given block in modal divs. Must give at least :body
  def modal(options = {})
    h.render 'modal',
      body:    options.delete(:body) || raise(ArgumentError, 'no :body given for modal'),
      header:  options.delete(:header) || '',
      footer:  options.delete(:footer) || '',
      classes: options.delete(:class)
  end

  # removes all modal boxes first, appends a new one to the body and opens it
  def append_modal(options = {})
    hide_modal
    remove_modal
    page.select('body').append(modal(options))
    select(:modal).modal('show')
  end

  def append_to_modal(html)
    select(:modal_body).append html
  end

  def prepend_to_modal(html)
    select(:modal_body).prepend html
  end

  def hide_modal(*a)
    if a.empty?
      page.select('.modal')
    else
      select(*a)
    end.modal('hide')
  end

  def clear_modal
    hide_modal
    select(:modal_body).html ''
  end

  def remove_modal
    hide_modal
    select(:modal).remove()
  end

  def selector_for(name, *more)
    case name
    when :modal
      '.modal'
    when :modal_body
      '.modal .modal-body'
    else
      super
    end
  end

end
