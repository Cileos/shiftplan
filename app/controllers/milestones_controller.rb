class MilestonesController < BaseController
  nested_belongs_to :account, :organization, :plan
  self.responder = Volksplaner::Responder
  respond_to :json

  protected

  def collection
    @milestones ||= end_of_association_chain.includes(:tasks)
  end
end
