class Activity::ElementObserver < ActiveRecord::Observer
  observe :requirement

  def after_save(object)
    update_requirements(object)
    Activity.flush
  end
  alias :after_destroy :after_save

  protected

    def update_requirements(object)
      activity = Activity.current || Activity.log('update', object.shift, User.first)
      requirements = object.shift.reload.requirements
      requirements.map! { |r| r.qualification.try(:name) || '[undefined]' }
      activity.changes[:to][:requirements] = requirements
    end
end
