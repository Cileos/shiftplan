# Decorator helpers dealing with an (ActiveRecord) model
class RecordDecorator < ApplicationDecorator
  def partial_name
    model.class.model_name.plural
  end

  def insert_new_form(heading='')
    append_modal body: h.render('new_form', scheduling: model),
      header: h.content_tag(:h3, heading)
  end
end
