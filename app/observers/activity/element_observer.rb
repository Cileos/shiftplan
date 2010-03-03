class Activity::ElementObserver < ActiveRecord::Observer
  observe :requirement

  def before_create(object)
    add_requirement(object)
  end
  
  def before_destroy(object)
    requirements(object.shift).delete(object.qualification.name)
  end
  
  def after_save(object)
    Activity.flush
  end
  alias :after_destroy :after_save
  
  protected
    def add_requirement(object)
      activity = Activity.current || Activity.log('update', object.shift, User.first)
      activity.changes[:to][:requirements] ||= []
      activity.changes[:to][:requirements] << object.qualification.name
    end
end
        