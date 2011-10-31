class EmployeesController < InheritedResources::Base
  def create
    create! { collection_url }
  end
end
