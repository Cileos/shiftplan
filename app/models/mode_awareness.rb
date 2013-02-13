module ModeAwareness
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def decorate(input, opts={})
      mode = opts.delete(:mode) || opts.delete('mode')
      if page = opts[:page]
        mode ||= page.view.current_plan_mode
      end
      unless mode
        raise ArgumentError, 'must give :mode in options'
      end
      unless mode.in?( supported_modes.map(&:to_s) )
        raise ArgumentError, "mode is not supported: #{mode}"
      end
      "#{decorated_class}Filter#{mode.classify}Decorator".constantize.new(input, opts)
    end

    def supported_modes
      [:teams_in_week]
    end

    def decorated_class
      self.name.scan(/^(.*)Filter/).first.first
    end
  end

  def mode
    @mode ||= self.class.name.scan(/Filter(.*)Decorator/).first.first.underscore
  end

  def mode?(query)
    mode.include?(query)
  end

end
