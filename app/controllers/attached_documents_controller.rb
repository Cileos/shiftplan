class AttachedDocumentsController < BaseController
  belongs_to :plan
  respond_to :js
end
