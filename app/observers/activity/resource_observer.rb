# hax da bug. https://rails.lighthouseapp.com/projects/8994/tickets/4087
ActiveRecord::Observer.class_eval do
  def add_observer!(klass)
    super
    self.class.observed_methods.each do |method|
      callback = :"_notify_observers_for_#{method}"
      if (klass.instance_methods & [callback, callback.to_s]).empty?
        klass.class_eval "def #{callback}; notify_observers(:#{method}); true; end"
        klass.send(method, callback)
      end
    end
  end
end

class Activity::ResourceObserver < ActiveRecord::Observer
  observe :plan, :shift, :assignment
  
  def before_create(object)
    log_activity('create', object)
  end
  
  def before_update(object)
    log_activity('update', object)
  end
  
  def before_destroy(object)
    log_activity('destroy', object)
  end
  
  def after_save(object)
    Activity.flush
  end
  alias :after_destroy :after_save
  
  protected
  
    def log_activity(action, object)
      Activity.log(action, object, Thread.current[:account], Thread.current[:user])
      true
    end
end

