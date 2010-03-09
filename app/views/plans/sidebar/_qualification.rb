class Plans::Sidebar::Qualification < Minimal::Template
  def content
    li do
      link_to(qualification.name, "/qualifications/#{id}", attributes)
    end
  end

  def attributes
    {
      :class => "#{qualification.class.name.underscore} #{dom_id(qualification)} dialog",
      :'data-possible-workplaces' => possible_workplaces
    }
  end

  def possible_workplaces
    qualification.possible_workplaces.map { |workplace| dom_id(workplace) }.join(', ')
  end
end

