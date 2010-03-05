class Presenter
  attr_reader :object, :view

  def initialize(object, view)
    @object = object
    @view = view

    (class << self; self; end).send(:define_method, model_name) { @object }
  end

  def model_name
    @model_name ||= if object.is_a?(Array)
      object.first.class.name.underscore.pluralize
    else
      object.class.name.underscore
    end
  end

  def id
    object.id
  end

  def path
    send(:"#{model_name}_path", object)
  end

  def to_s
    render
  end

  [:h1, :h2, :h3, :h4, :div, :ol, :ul, :li, :span, :table, :th, :tr, :td].each do |tag_name|
    class_eval <<-code, __FILE__, __LINE__
      def #{tag_name}(*args, &block)
        content_tag(:#{tag_name}, *args, &block)
      end

      def #{tag_name}_for(*args, &block)
        content_tag_for(:#{tag_name}, *args, &block)
      end
    code
  end

  def method_missing(method, *args, &block)
    return object.send(method, *args, &block) if object.respond_to?(method)
    return view.send(method, *args, &block) if view.respond_to?(method)
    super
  end
end
