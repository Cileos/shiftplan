module OvernightableDecoratorHelper
  # Canonical id
  # Makes sure that always the first day of an overnightable is edited.
  # The second day, if present, gets updated in after callbacks accordingly.
  def cid_for_overnightable
    if record.previous_day
      record.previous_day.id
    else
      record.id
    end
  end

  def metadata
    super.merge(cid: cid_for_overnightable, pairing: pairing_id)
  end

  def nightshift_class
    if previous_day.present?
      'early'
    elsif next_day.present?
      'late'
    end
  end

  def respond_for_update(resource)
    update_cell_for(resource.with_previous_changes_undone)
    if resource.next_day
      update_cell_for(resource.next_day.with_previous_changes_undone)
    end
    super
  end
end
