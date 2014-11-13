module OvernightableDecoratorHelper
  # holds the currently rendered column, eg. which part of the nightshift is to be rendered
  attr_writer :focus_day
  def focus_day
    @focus_day
  end

  def metadata
    super.merge(cid: record.id, pairing: record.id)
  end

  def nightshift_class
    if early?
      'early'
    elsif late?
      'late'
    end
  end

  def late?
    is_overnight? && starts_on_focussed_day?
  end

  def early?
    is_overnight? && ends_on_focussed_day?
  end

  def length_in_hours
    if is_overnight?
      if starts_on_focussed_day?
        length_in_hours_until_midnight
      else
        length_in_hours_from_midnight
      end
    else
      object.length_in_hours
    end
  end

  def start_hour
    if is_overnight? && ends_on_focussed_day?
      0
    else
      object.start_hour
    end
  end

  def start_metric_hour
    if is_overnight? && ends_on_focussed_day?
      0
    else
      object.start_metric_hour
    end
  end
end
