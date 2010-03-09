class Plans::Show::Workplace < Minimal::Template
  def content
    ul :class => "workplace #{dom_id(workplace)} shifts" do
      shifts.map { |shift| render :partial => 'plans/show/shift', :object => shift }
    end
  end
end
