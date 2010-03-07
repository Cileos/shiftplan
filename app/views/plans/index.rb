class Plans::Index < Minimal::Template
  def content
    h1 'Plans'
    table :id => 'plans' do
      tr do
        ths = ['Name', 'Start date', 'End date', 'Shifts', '']
        ths.each { |text| th(text) }
      end
      plans.each { |plan| render(:partial => plan) }
    end
    render(:partial => 'form')
  end
end