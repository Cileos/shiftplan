class DefaultStatuses::Day < Minimal::Template
  def content
    td(:id => "#{dom_id(employee)}_day_#{day_of_week}") do
      ul(:class => 'statuses') do
        render(:partial => 'default_statuses/default_status', :collection => statuses, :locals => { :employee => employee })
      end
    end
  end
end
