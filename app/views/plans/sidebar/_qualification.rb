class Plans::Sidebar::Qualification < Minimal::Template
  def to_html
    li do
      link_to(qualification.name, qualification_path(qualification), attributes)
    end
  end

  def attributes
    {
      :class => "#{qualification.class.name.underscore} #{dom_id(qualification)} dialog",
      :'data-possible-workplaces' => qualified_workplaces
    }
  end

  def qualified_workplaces
    qualification.qualified_workplaces.map { |workplace| dom_id(workplace) }.join(', ')
  end
end

