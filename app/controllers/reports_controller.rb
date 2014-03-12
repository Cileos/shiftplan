class ReportsController < InheritedResources::Base
  nested_belongs_to :account
  defaults resource_class: Scheduling, collection_name: 'schedulings', instance_name: 'scheduling'
  load_and_authorize_resource class: Scheduling

  def total_duration
    total_minutes = @schedulings.reject(&:previous_day).sum { |s| s.send(:length_in_minutes) }
    '%d:%02d' % [total_minutes / 60, total_minutes % 60]
  end
  helper_method :total_duration

  skip_authorization_check
  before_filter :authorize_read_report

  protected

  def authorize_read_report
    authorize! :read_report, current_account
  end
end

