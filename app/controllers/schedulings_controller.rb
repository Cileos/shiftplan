class SchedulingsController < InheritedResources::Base
  nested_belongs_to :plan
  actions :all, :except => [:show, :index]

  respond_to :html, :js
end
