require 'core_ext/hash/compact'

class Activity < ActiveRecord::Base
  self.inheritance_column = 'none'

  belongs_to :user
  belongs_to :object, :polymorphic => true
  serialize  :changes

  scope :to_aggregate, lambda {
    scope = unaggregated
    scope = scope.where('created_at < ?', session_timeout.minutes.ago) if session_timeout
    scope
  }

  # note: arel + scopes + unmigrated tables = boom!
  scope :unaggregated, :conditions => { :aggregated_at => nil }   # where(:aggregated_at => nil)
  scope :aggregated,   :conditions => "aggregated_at IS NOT NULL" # where('aggregated_at IS NOT NULL')

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
        :changes     => object.send(:"log_#{action}").compact,
        :user        => user,
        :user_name   => user && user.name,
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
        activity.changes[:from].reverse_merge!(other.changes[:from] || {}) if activity.changes[:from]
        activity.changes[:to].merge!(other.changes[:to])
        activity
      end
      activity.changes.delete(:from) if activity.created? || last.destroyed?

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