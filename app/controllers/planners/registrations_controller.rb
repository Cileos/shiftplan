class Planners::RegistrationsController < Devise::RegistrationsController
  after_filter :create_organization_and_employee_and_blog, :only => :create

  protected

  def create_organization_and_employee_and_blog
    unless resource.new_record?
      organization = Organization.create! :name => organization_name
      organization.blogs.create! :title => 'Company Blog'
      resource.employees.create! do |e|
        e.first_name = resource.first_name.present? ? resource.first_name : resource.email
        e.last_name  = resource.last_name.present? ? resource.last_name : nil
        e.organization = organization
        e.role = 'owner'
      end
    end
  end

  def organization_name
    resource.organization_name.present? ? resource.organization_name : "Organization for #{resource.label}"
  end
end

