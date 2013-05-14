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
end
