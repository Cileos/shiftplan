module Tutorial::Controller

  def self.included(controller)
    controller.class_eval do
      extend ClassMethods
      attr_accessor :current_tutorial
    end
  end

  module ClassMethods
    # last one matching will be used
    def tutorial(name, opts={})
      before_filter opts do |ctrl|
        ctrl.current_tutorial = name
      end
    end
  end

end

