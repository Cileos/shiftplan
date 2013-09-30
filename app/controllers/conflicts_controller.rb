class ConflictsController < BaseController
  belongs_to :scheduling
  respond_to :js

  private

  def resource
    @conflict ||= ConflictFinder.find_conflict_for(parent)
  end
end
