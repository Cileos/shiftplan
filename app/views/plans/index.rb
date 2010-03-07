class Plans::Index < Minimal::Template
  def content
    h1 'Plans'
    table :id => 'plans' do
      tr do
        th 'Name'
        th 'Start date'
        th 'End date'
        th 'Shifts'
        th
      end
      render(:partial => plans)
    end
    render(:partial => 'form')
  end
end