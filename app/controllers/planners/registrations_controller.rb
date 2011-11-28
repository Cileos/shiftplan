class Planners::RegistrationsController < Devise::RegistrationsController
  after_filter :assign_planner_role, :only => :create

  protected

  def assign_planner_role
    unless resource.new_record?
      resource.roles << 'planner'
      resource.save!
    end
  end
end

