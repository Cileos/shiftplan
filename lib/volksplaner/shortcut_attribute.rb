module Volksplaner::ShortcutAttribute

  def self.included(model)
    model.class_eval do
      validates_length_of :shortcut, maximum: 4
    end
  end

  def shortcut
    super.presence || shortcut_from_name
  end

  # display unsaved default value in form
  def shortcut_before_type_cast
    shortcut
  end

  def shortcut_from_name
    name.split(/[\-\s]/).map(&:first).join if name
  end
end
