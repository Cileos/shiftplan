class QualificationPresenter < Presenter
  def attributes
    { 
      :class => "#{qualification.class.name.underscore} #{dom_id(qualification)} dialog",
      :'data-possible-workplaces' => possible_workplaces.join(', ')
    }
  end
  
  def possible_workplaces
    qualification.possible_workplaces.map { |workplace| dom_id(workplace) }
  end
  
  def render
    li do
      link_to(name, "/qualifications/#{id}", attributes)
    end
  end
end

