class ApplicationDecorator < Draper::Decorator
  include ModalDecoratorHelper
  include ResponderDecoratorHelper

  def dom_id(m=source)
    h.dom_id(m)
  end

  def selector_for(name, resource=nil, *more)
    case name
    when :errors_for
      %Q~#{selector_for(:form_for, resource)} .errors~
    when :form_for
      if resource.to_key
        %Q~form##{h.dom_id resource, :edit}~
      else
        %Q~form##{h.dom_id resource}~
      end
    when :tabs_for
      %Q~##{h.dom_id(resource, 'tabs')}~
    else
      begin
        super
      rescue NoMethodError => no_method
        raise ArgumentError, "cannot find selector for #{name}"
      end
    end
  end

  # select a specific element on the page. You may implement #selector_for in your subclass
  def select(*a)
    page.select selector_for(*a)
  end

  # OPTIMIZE trigger is not chainable
  def remove(*a)
    # event is namespaced to not accidently trigger closing the dialog box
    select(*a).trigger('clockwork.remove')
    select(*a).remove()
  end

  # prepend validation errors for given `resource` to its form
  def prepend_errors_for(resource)
    select(:errors_for, resource).remove()
    select(:form_for, resource).prepend errors_for(resource)
  end

  # append validation errors for given `resource` to its form
  def append_errors_for(resource)
    select(:errors_for, resource).remove()
    select(:form_for, resource).append errors_for(resource)
  end

  def errors_for(resource)
    h.content_tag :div, resource.errors.full_messages.to_sentence, class: 'flash alert errors'
  end

  def update_flash
    page['flash'].remove()
    page.select('section[role=content]').prepend render_flash
  end

  def render_flash
    h.render('application/flash')
  end

  def update_navigation
    page.select('nav[role=navigation]').html(h.render('accounts/navigation'))
  end

  # Lazy Helpers
  #   PRO: Call Rails helpers without the h. proxy
  #        ex: number_to_currency(source.price)
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

  private

    def resource_name
      @resource_name ||= source.class.name.underscore
    end

    def pluralized_resource_name
      resource_name.pluralize
    end
end
