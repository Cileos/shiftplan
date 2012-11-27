module Volksplaner
  # can be used directly by name or by
  #
  #   f.button :update # => update_button
  #
  # The labels are icon-enabled. Given an :action, they will render its text
  # and corresponding icon as old-style I tag.
  #
  # TODO specify new-style data-icon
  # TODO always add data-disable-with, overridable, but with sensual defaults

  module FormButtons
    # If you want to specify the label yourself.
    #
    #   f.responsive_submit_button :action_name
    #
    def responsive_submit_button(*a, &block)
      options = a.extract_options!
      if options[:class].is_a?(String)
        options[:class] = options[:class].split
      end
      options[:class] ||= []
      options[:class] << 'button-success'
      options[:type] = 'submit'

      options[:class] = options[:class].join(' ')
      if block_given?
        template.content_tag(:button, options, &block)
      else
        label = a.first || options[:label] || options[:name] || '[Give title as first param]'
        label = template.ti(label) if label.is_a?(Symbol)
        template.content_tag(:button, label, options)
      end
    end
 
    # standard Update Button
    def update_button(*a, &block)
      responsive_submit_button template.ti(:update)
    end

    # standard Create Button
    def create_button(*a, &block)
      responsive_submit_button template.ti(:create)
    end
  end
end
