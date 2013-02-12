# Decorator helpers dealing with an (ActiveRecord) model
class RecordDecorator < ApplicationDecorator
  delegate :errors

  # Models can be called by name, for example :post in the PostDecorator
  def self.decorates(*a)
    super
    alias_method a.first, :source
  end

  def partial_name
    source.class.model_name.plural
  end

  def insert_new_form(heading='')
    append_modal body: h.render('new_form', scheduling: source),
      header: h.content_tag(:h3, heading)
  end
end
