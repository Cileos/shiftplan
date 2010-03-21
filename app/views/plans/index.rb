class Plans::Index < Minimal::Template
  def content
    h1 t(:"navigation.plans")
    table :id => 'plans' do
      tr { [t(:"activerecord.attributes.plan.name"), 
            t(:"activerecord.attributes.plan.start"), 
            t(:"activerecord.attributes.plan.end"), 
            t(:"activerecord.attributes.plan.shifts"), nil].each { |name| th name } }
      render :partial => plans
    end
    render :partial => 'form'
  end
end
