require 'spec_helper'

describe 'schedulings/_fields.html.haml' do
  let(:form_builder) { stub('form builder', object: scheduling).as_null_object }
  let(:scheduling)   { stub('scheduling', date: Date.today).as_null_object }

  before :each do
    view.stub(:current_account).and_return(stub.as_null_object)
  end

  it "asks helper for selectable employees" do
    employees = [stub, stub]
    view.should_receive(:employees_for_select).with(scheduling).and_return(employees)
    form_builder.should_receive(:association).with(:employee, as: :select, collection: employees)
    render_partial locals: { f: form_builder }
  end

end
