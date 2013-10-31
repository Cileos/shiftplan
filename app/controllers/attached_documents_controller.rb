class AttachedDocumentsController < BaseController
  belongs_to :plan
  respond_to :js

  def build_resource(*)
    super.tap do |doc|
      doc.uploader = current_employee
    end
  end

  def interpolation_options
    { name: resource.name }
  end
end