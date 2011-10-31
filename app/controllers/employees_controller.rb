class EmployeesController < InheritedResources::Base
  def create
    create! { collection_url }
  end

  private

  # TODO more than one organization per planer
  def begin_of_association_chain
    current_user.organization
  end
end
