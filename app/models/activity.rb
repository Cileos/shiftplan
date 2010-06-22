class Activity < ActiveRecord::Base
  self.inheritance_column = 'none'

  belongs_to :user
  belongs_to :object, :polymorphic => true
  serialize  :alterations

  scope :to_aggregate, lambda {
    scope = unaggregated
    scope = scope.where('created_at < ?', session_timeout.minutes.ago) if session_timeout
    scope
  }

  scope :unaggregated, lambda { where(:aggregated_at => nil) }
  scope :aggregated,   lambda { where('aggregated_at IS NOT NULL') }

  class << self
    def session_timeout
      defined?(@session_timeout) ? @session_timeout : 10
    end

    def session_timeout=(timeout)
      @session_timeout = timeout
    end

    def current
      Thread.current[:activity]
    end

    def current=(activitiy)
      Thread.current[:activity] = activitiy
    end

    def flush
      current.save! if current
      Thread.current[:activity] = nil
    end

    def log(action, object, user)
      self.current = Activity.new(
        :action      => action.to_s,
        :object      => object, # FIXME can potentially run into endless loop
        :alterations => object.send(:"log_#{action}").compact,
        :user        => user,
        :user_name   => user && (user.name || user.email),
        :started_at  => Time.zone.now
      )
    end

    def aggregate!
      to_aggregate.group_by(&:object_key).each do |key, activities|
        canceled?(activities) ? delete(activities) : merge(activities)
      end
    end

    def canceled?(activities)
      activities.first.created? && activities.last.destroyed?
    end

    def merge(activities)
      activity = activities.shift
      last     = activities.last || activity

      activity = activities.inject(activity) do |activity, other|
        activity.alterations[:from].reverse_merge!(other.alterations[:from] || {}) if activity.alterations[:from]
        activity.alterations[:to].merge!(other.alterations[:to] || {})             if activity.alterations[:to]
        activity
      end
      activity.alterations.delete(:from) if activity.created? || last.destroyed?

      activity.update_attributes!(
        :action        => activity.created? ? 'create' : last.action,
        :finished_at   => last.started_at,
        :aggregated_at => Time.zone.now
      )
      delete(activities)
    end
  end

  def object_key
    "#{object_type}_#{object_id}"
  end

  def created?
    action == 'create'
  end

  def destroyed?
    action == 'destroy'
  end

  def aggregated?
    !aggregated_at.nil?
  end

  def status
    aggregated? ? 'aggregated' : 'unaggregated'
  end
end