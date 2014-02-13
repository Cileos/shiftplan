class ReportsController < InheritedResources::Base
  nested_belongs_to :account, :organization
  defaults resource_class: Scheduling, collection_name: 'schedulings', instance_name: 'scheduling'
  load_and_authorize_resource class: Scheduling
end
