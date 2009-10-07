# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # def time_by_slot(hour, slot)
  #   [sprintf("%02d", hour), sprintf("%02d", slot * 15)].join(':')
  # end
  
  def presenter_for(model)
    "#{model.class.name}Presenter".constantize.new(model, self)
  end
end
