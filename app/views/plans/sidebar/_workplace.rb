class Plans::Sidebar::Workplace < Minimal::Template
  def to_html
    li do
      link_to(workplace.name, workplace_path(workplace), attributes)
    end
  end

  def attributes
    {
      :class => "#{workplace.class.name.underscore} #{dom_id(workplace)} dialog",
      :'data-workplace-id' => workplace.id,
      :'data-default-shift-length' => workplace.default_shift_length,
      :'data-default-staffing' => workplace.default_staffing.to_json
    }
  end
end

