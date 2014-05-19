# Decorator helpers dealing with an (ActiveRecord) model
class RecordDecorator < ApplicationDecorator
  delegate_all

  # Models can be called by name, for example :post in the PostDecorator
  def self.decorates(*a)
    super
    alias_method a.first, :source
  end

  def partial_name
    source.class.model_name.singular
  end

  def partials_dir_name
    source.class.model_name.plural
  end

  def insert_new_form(heading='', model_name)
    append_modal body: h.render('new_form', model_name => model),
      header: heading
  end

  def metadata
    {}
  end

  def error_messages
    unless errors.empty?
      errors_for(source)
    end
  end


  private

    def record
      model
    end
end
