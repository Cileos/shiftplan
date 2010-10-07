module Plans
  class Show::Requirement < Minimal::Template
    delegate :assignee, :qualification, :to => :requirement

    def to_html
      li(requirement, attributes) { link_to_assignee }
    end

    def link_to_assignee
      if assignee
        classes = "assignment #{dom_id(assignee)} dialog"
        classes << "qualification_#{qualification.id}" if qualification
        link_to(''.html_safe, employee_path(assignee), :class => classes)
      end
    end

    def attributes
      {
        :class => qualification ? "qualification_#{qualification.id}" : '',
        :'data-qualified_employee_ids' => requirement.qualified_employee_ids.to_json
      }
    end
  end
end
