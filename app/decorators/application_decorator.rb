class ApplicationDecorator < Draper::Base

  # wraps the given block in modal divs. Must give at least :body
  def modal(options = {})
    body    = options.delete(:body) || raise(ArgumentError, 'no :body given for modal')
    classes = options.delete(:class)
    content = h.content_tag :div, body, class: 'modal-body'
    h.content_tag :div, content, options.merge(class: "modal hide fade in #{classes}")
  end

  def dom_id
    h.dom_id(model)
  end

  def scheduling_form_id
    'scheduling_modal'
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
