class AttachedDocumentsController < BaseController
  nested_belongs_to :account, :organization, :plan
  respond_to :js

  def destroy
    destroy! do |success|
      success.html { nested_resources_for(plan) }
    end
  end

  def build_resource(*)
    super.tap do |doc|
      doc.uploader = current_employee
    end
  end

  def interpolation_options
    { name: resource.name }
  end
end
