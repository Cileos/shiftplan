# Decorator helpers dealing with an (ActiveRecord) model
class RecordDecorator < ApplicationDecorator
  def partial_name
    model.class.model_name.plural
  end

  def insert_new_form(heading='', model_name)
    append_modal body: h.render('new_form', model_name => model),
      header: h.content_tag(:h3, heading)
  end

  # Makes sure that always the first day of an overnightable is edited.
  # The second day, if present, gets updated in after callbacks accordingly.
  def edit_url
    record_or_previous_day_record = if record.previous_day.present?
      record.previous_day
    else
      record
    end
    h.url_for([:edit] + h.nested_resources_for(record_or_previous_day_record))
  end

  def metadata
    local_metadata.merge(edit_url: edit_url)
  end


  private

    def record
      model
    end

    # override in subclass, if you need more metadata
    def local_metadata
      {}
    end
end
