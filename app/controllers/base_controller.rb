class BaseController < InheritedResources::Base
  load_and_authorize_resource

  private

  def end_of_association_chain
    if resource_class.respond_to?(:default_sorting)
      super.default_sorting
    else
      super
    end
  end
end
