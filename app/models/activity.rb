class Activity < ActiveRecord::Base
  module Logging
    def self.included(base)
      base.class_inheritable_accessor :activity_attrs
    end
    
    def log_create
      { :to => attributes.slice(*activity_attrs).symbolize_keys }
    end
    alias :log_destroy :log_create

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
    def log(action, object, user)
      create! :action     => action.to_s,
              :object     => object,
              :changes    => object.send(:"log_#{action}"),
              :user       => user,
              :user_name  => user.name,
              :started_at => Time.zone.now
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
      activity = activities.inject(activities.shift) do |activity, other|
        activity.changes[:to].merge!(other.changes[:to])
        activity
      end
      activity.update_attributes!(
        :action        => activity.action == 'create' ? 'create' : activities.last.action,
        :changes       => activity.changes[:to],
        :finished_at   => activities.last.started_at,
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