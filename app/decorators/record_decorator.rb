# Decorator helpers dealng with an (ActiveRecord) model
class RecordDecorator < ApplicationDecorator
  def partial_name
    model.class.model_name.plural
  end

  def insert_new_form
    append_modal body: h.render('new_form', scheduling: model)
  end
end
