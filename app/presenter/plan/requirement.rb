module Presenter
  class Plan
    class Requirement < Base
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
        link_to('', employee_path(assignee), :class => "assignment #{dom_id(assignee)} qualification_#{qualification.id} dialog")
      end
    end
  end
end
