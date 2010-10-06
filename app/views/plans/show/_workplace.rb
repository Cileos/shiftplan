module Plans
  class Show::Workplace < Minimal::Template
    def to_html
      ul :class => "workplace #{dom_id(workplace)} shifts" do
        shifts.map { |shift| render :partial => 'plans/show/shift', :object => shift }
      end
    end
  end
end
