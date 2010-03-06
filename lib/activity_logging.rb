module ActivityLogging
  def self.included(base)
    base.class_inheritable_accessor(:activity_attrs)
  end

  def save_with_logging(user)
    action = new_record? ? 'create' : 'update'
    Activity.log(action, self, user) if valid?
    save
  end

  def log_create
    { :to => activity_attrs.inject({}) { |result, name| result[name.to_sym] = send(name); result } }
  end
  alias :log_destroy :log_create

  def log_attributes(map)
    # TODO map assoc objects with :qualification => name
    map.inject({}) { |result, name| result[name] = send(name) }
  end

  def log_update
    log = changes.slice(*activity_attrs).inject(:from => {}, :to => {}) do |log, (name, change)|
      log[:from][name.to_sym] = change.first
      log[:to][name.to_sym]   = change.last
      log
    end
    log
  end
end

ActiveRecord::Base.send(:include, ActivityLogging)
