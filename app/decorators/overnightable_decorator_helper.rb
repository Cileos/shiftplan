module OvernightableDecoratorHelper
  # Makes sure that always the first day of an overnightable is edited.
  # The second day, if present, gets updated in after callbacks accordingly.
  def edit_url_for_overnightable
    record_or_previous_day_record = if record.previous_day.present?
      record.previous_day
    else
      record
    end
    h.url_for([:edit] + h.nested_resources_for(record_or_previous_day_record))
  end

  def scheduling_pairing_id
    if record.previous_day.present?
      record.previous_day.id
    elsif record.next_day.present?
      record.id
    end
  end

  def metadata
    super.merge(edit_url: edit_url_for_overnightable, pairing: scheduling_pairing_id)
  end

  def nightshift_class
    if previous_day.present?
      'early'
    elsif next_day.present?
      'late'
    end
  end
end
