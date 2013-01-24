module WithPreviousChangesUndone
  def with_previous_changes_undone
    dup.tap do |copy|
      copy.attributes = attributes_for_undo
    end
  end

  def attributes_for_undo
    previous_changes.map { |k,(o,n)| { k => o }}.inject(&:merge)
  end
end
