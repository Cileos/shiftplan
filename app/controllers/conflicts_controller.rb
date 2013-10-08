class ConflictsController < BaseController
  belongs_to :scheduling
  respond_to :js

  private

  def resource
    @conflict ||= conflict_finder_class.find_conflict_for(parent)
  end

  def conflict_finder_class
    if parent.user == current_user
      UserConflictFinder
    else
      ConflictFinder
    end
  end
end
