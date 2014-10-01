module OvernightableDecoratorHelper
  # holds the currently rendered column, eg. which part of the nightshift is to be rendered
  attr_writer :focus_day
  def focus_day
    @focus_day || raise('must set #focus_day for overnightables')
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
end
