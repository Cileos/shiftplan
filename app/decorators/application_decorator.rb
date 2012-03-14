class ApplicationDecorator < Draper::Base

  # wraps the given block in modal divs. Must give at least :body
  def modal(options = {})
    body    = options.delete(:body) || raise(ArgumentError, 'no :body given for modal')
    header  = options.delete(:header)
    classes = options.delete(:class)
    content_body = h.content_tag :div, body, class: 'modal-body'
    if header
      content = h.content_tag(:div, header, class: 'modal-header')
      content += content_body
    else
      content = content_body
    end
    h.content_tag :div, content, options.merge(class: "modal container-fluid hide fade in #{classes}")
  end

  # removes all modal boxes first, appends a new one to the body and opens it
  def append_modal(options = {})
    page.select('.modal').remove()
    page.select('body').append(modal(options))
    page.select('.modal').modal('show')
  end

  def dom_id(m=model)
    h.dom_id(m)
  end

  def scheduling_form_id
    'scheduling_modal'
  end

  def selector_for(name, resource=nil, *more)
    case name
    when :scheduling_form
      '#' + scheduling_form_id
    when :errors_for
      %Q~#{selector_for(:form_for, resource)} .errors~
    when :form_for
      if resource.to_key
        %Q~form##{h.dom_id resource, :edit}~
      else
        %Q~form##{h.dom_id resource}~
      end
    else
      raise ArgumentError, "cannot find selector for #{name}"
    end
  end

  # select a specific element on the page. You may implement #selector_for in your subclass
  def select(*a)
    page.select selector_for(*a)
  end

  def remove(*a)
    select(*a).remove()
  end

  def hide_modal(*a)
    if a.empty?
      page.select('.modal')
    else
      select(*a)
    end.modal('hide')
  end

  # append validation errors for given `resource` to its form
  def insert_errors_for(resource)
    select(:errors_for, resource).remove()
    select(:form_for, resource).append errors_for(resource)
  end

  def errors_for(resource)
    h.content_tag :div, resource.errors.full_messages.to_sentence, class: 'alert alert-error errors'
  end

  # Lazy Helpers
  #   PRO: Call Rails helpers without the h. proxy
  #        ex: number_to_currency(model.price)
  #   CON: Add a bazillion methods into your decorator's namespace
  #        and probably sacrifice performance/memory
  #
  #   Enable them by uncommenting this line:
  #   lazy_helpers

  # Shared Decorations
  #   Consider defining shared methods common to all your models.
  #
  #   Example: standardize the formatting of timestamps
  #
  #   def formatted_timestamp(time)
  #     h.content_tag :span, time.strftime("%a %m/%d/%y"),
  #                   :class => 'timestamp'
  #   end
  #
  #   def created_at
  #     formatted_timestamp(model.created_at)
  #   end
  #
  #   def updated_at
  #     formatted_timestamp(model.updated_at)
  #   end
end
