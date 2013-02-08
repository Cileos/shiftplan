module Volksplaner
  # can be used directly by name or by
  #
  #   f.button :update # => update_button
  #
  # The labels are icon-enabled. Given an :action, they will render its text
  # and corresponding icon as old-style I tag.
  #
  # TODO specify new-style data-icon

  module FormButtons
    # If you want to specify the label yourself.
    #
    #   f.responsive_submit_button :action_name
    #
    # If you do, it will will look for an action named :action_name_busy to set
    # the busy/disabled text on click of the User.
    #
    def responsive_submit_button(*a, &block)
      options = a.extract_options!
      if options[:class].is_a?(String)
        options[:class] = options[:class].split
      end
      options[:class] ||= []
      options[:class] << 'button-success'
      options[:type] = 'submit'

      label = a.first || options[:label] || options[:name] || '[Give title as first param]'

      busy_label = options.delete(:disabled_label) || options.delete(:busy_label)
      if label.is_a?(Symbol)
        busy_label ||= template.translate_action!(:"#{label}_busy") rescue nil
      end
      busy_label ||= '...'


      options['data-disable-with'] = busy_label

      options[:class] = options[:class].join(' ')
      if block_given?
        template.content_tag(:button, options, &block)
      else
        label = template.ta(label) if label.is_a?(Symbol)
        template.content_tag(:button, label, options)
      end
    end

    # standard Update Button
    def update_button(*a, &block)
      responsive_submit_button :update
    end

    # standard Create Button
    def create_button(*a, &block)
      responsive_submit_button :create
    end

    def create_or_update_button(*a, &block)
      if object.new_record?
        create_button(*a, &block)
      else
        update_button(*a, &block)
      end
    end
  end
end
