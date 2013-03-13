require 'spec_helper'

describe "schedulings/lists/_employees_in_week.html.haml" do
  def partial_name
    subject.sub(%r~/_([^/]+)$~, '/\1').sub(/(\.\w+){2}$/,'')
  end
  def render_list(list)
    render partial: partial_name, locals: { schedulings: list }
  end
  # returns a new stub as null object, having ALL methods defined
  def sch(attrs={})
    stub('scheduling', attrs).as_null_object
  end
  before :each do
    view.stub(:can?).and_return(true)
    view.stub(:nested_resources_for).and_return('/')
  end

  it "displays period of one scheduling" do
    render_list [sch(period: 'forever')]
    rendered.should include('forever')
  end
  it "displays period of multiple schedulings" do
    render_list [sch(period: 'forever'), sch(period: "and ever"), sch(period: "and never ever")]
    rendered.should include('forever')
    rendered.should include('and ever')
    rendered.should include('and never ever')
  end
end
