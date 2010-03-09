class Plans::Show::Shift < Minimal::Template
  delegate :workplace, :requirements, :to => :shift

  def content
    li_for shift, attributes do
      h3 workplace.name
      ul :class => 'requirements' do
        render :partial => 'plans/show/requirement', :collection => requirements
      end
    end
  end

  def attributes
    {
      :class => dom_id(workplace),
      :'data-workplace-id' => workplace.id,
      :'data-start' => shift.start_in_minutes,
      :'data-duration' => shift.duration
    }
  end
end

