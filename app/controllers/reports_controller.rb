class ReportsController < InheritedResources::Base
  nested_belongs_to :account, :organization
  defaults resource_class: Scheduling, collection_name: 'schedulings', instance_name: 'scheduling'
  load_and_authorize_resource class: Scheduling

  def total_duration
    total_minutes = @schedulings.reject(&:previous_day).sum { |s| s.send(:length_in_minutes) }
    '%d:%02d' % [total_minutes / 60, total_minutes % 60]
  end
  helper_method :total_duration

end

