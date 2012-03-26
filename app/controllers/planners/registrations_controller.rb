class Planners::RegistrationsController < Devise::RegistrationsController
  after_filter :create_employee_and_organization, :only => :create

  protected

  def create_employee_and_organization
    unless resource.new_record?
      organization = Organization.create! :name => "Organization for #{resource.label}"
      resource.employees.create! do |e|
        e.first_name = resource.email
        e.last_name  = resource.email
        e.organization = organization
        e.role = 'owner'
      end
    end
  end
end

