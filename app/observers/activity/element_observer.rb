class Activity::ElementObserver < ActiveRecord::Observer
  observe :requirement

  def before_create(object)
    preserve_requirements(object)
  end

  def after_save(object)
    update_requirements(object)
    Activity.flush
  end
  alias :after_destroy :after_save

  protected

    def preserve_requirements(object)
      requirements = object.shift.requirements
      requirements.map! { |r| r.qualification.try(:name) || '[undefined]' }
      unless requirements.empty?
        activity = Activity.current || Activity.log('update', object.shift, User.first)
        activity.changes[:from] ||= {}
        activity.changes[:from][:requirements] = requirements
      end
    end

    def update_requirements(object)
      requirements = object.shift.reload.requirements
      requirements.map! { |r| r.qualification.try(:name) || '[undefined]' }
      activity = Activity.current || Activity.log('update', object.shift, User.first)
      activity.changes[:to] ||= {}
      activity.changes[:to][:requirements] = requirements
    end
end
