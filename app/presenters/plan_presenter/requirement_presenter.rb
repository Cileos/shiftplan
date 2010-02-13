class PlanPresenter
  class RequirementPresenter < Presenter
    def assignee
      assignment.assignee if assignment
    end

    def attributes
      {
        :class => qualification ? "qualification_#{qualification.id}" : '',
      }
    end

    def render
      li_for(requirement, attributes) do
        link_to_assignee if assignee
      end
    end

    def link_to_assignee
      if assignee
        classes = "assignment #{dom_id(assignee)} dialog"
        classes << "qualification_#{qualification.id}" if qualification
        link_to('', employee_path(assignee), :class => classes)
      end
    end
  end
end
