class Presenter
  attr_reader :object, :view

  def initialize(object, view)
    @object = object
    @view = view

    (class << self; self; end).send(:define_method, model_name) { @object }
  end

  def model_name
    object.class.name.underscore
  end

  def id
    object.id
  end

  def path
    send :"#{model_name}_path", object
  end

  def to_s
    render
  end

  [:div, :ol, :ul, :li, :h1, :h2, :h3, :h4, ].each do |tag_name|
    # define_method(tag_name) do |*args, &block|
    #   content_tag(tag_name, *args, &block)
    # end
    # 
    # define_method(:"#{tag_name}_for") do |*args, &block|
    #   content_tag_for(tag_name, *args, &block)
    # end

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