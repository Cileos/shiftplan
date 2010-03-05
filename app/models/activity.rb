class Activity < ActiveRecord::Base
  module Logging
    def self.included(base)
      base.class_inheritable_accessor :activity_attrs
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
      map.inject({}) do |result, name|
        # TODO map :qualification => name
        result[name] = send(name)
      end
    end

    def log_update
      changes.slice(*activity_attrs).inject(:from => {}, :to => {}) do |log, (name, change)|
        log[:from][name.to_sym] = change.first
        log[:to][name.to_sym]   = change.last
        log
      end
    end
  end
  ActiveRecord::Base.send(:include, Logging)

  self.inheritance_column = 'none'

  belongs_to :user
  belongs_to :object, :polymorphic => true
  serialize  :changes

  scope :to_aggregate, where(:aggregated_at => nil)

  class << self
    def current
      Thread.current[:activity]
    end

    def current=(activitiy)
      Thread.current[:activity] = activitiy
    end

    def flush
      current.save! if current # .changed? # this only seems to catch changes when done through attr accessors
      Thread.current[:activity] = nil
    end

    def log(action, object, user)
      self.current = Activity.new(
        :action      => action.to_s,
        :object      => object, # FIXME can run into endless loop
        :changes     => object.send(:"log_#{action}"),
        :user        => user,
        :user_name   => user.name,
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
        activity.changes[:to].merge!(other.changes[:to])
        activity
      end

      activity.update_attributes!(
        :action        => activity.action == 'create' ? 'create' : last.action,
        :changes       => activity.changes[:to],
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
end