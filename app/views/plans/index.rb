class Plans::Index < Minimal::Template
  def content
    h1 'Plans'
    table :id => 'plans' do
      tr { ['Name', 'Start date', 'End date', 'Shifts', nil].each { |name| th name } }
      render :partial => plans
    end
    render :partial => 'form'
  end
end
