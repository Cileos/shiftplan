class Planners::RegistrationsController < Devise::RegistrationsController
  after_filter :create_organization_and_employee_and_blog, :only => :create

  protected

  def create_organization_and_employee_and_blog
    unless resource.new_record?
      organization = Organization.create! :name => "Organization for #{resource.label}"
      organization.blogs.create! :title => 'Company Blog'
      resource.employees.create! do |e|
        e.first_name = resource.email
        e.last_name  = resource.email
        e.organization = organization
        e.role = 'owner'
      end
    end
  end
end

