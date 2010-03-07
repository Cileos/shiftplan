module Minimal
  class Presenter < Template
    attr_reader :object

    def initialize(object, view)
      super(view)
      @object = object
      (class << self; self; end).send(:define_method, model_name) { @object }
    end
    
    def t(*args)
      I18n.t(*args).html_safe
    end

    def l(*args)
      I18n.l(*args).html_safe
    end

    def id
      object.id
    end

    def path
      send(:"#{model_name}_path", object)
    end

    def url
      send(:"#{model_name}_url", object)
    end

    def model_name
      @model_name ||= object.is_a?(Array) ?
        object.first.class.name.underscore.pluralize :
        object.class.name.underscore
    end
  end
end

