class PlansController < InheritedResources::Base
  before_filter :authenticate_user!

  def begin_of_association_chain
    current_user.organization
  end
end
