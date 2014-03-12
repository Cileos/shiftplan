class ReportsController < InheritedResources::Base
  nested_belongs_to :account
  defaults resource_class: Scheduling, collection_name: 'schedulings', instance_name: 'scheduling'
  load_and_authorize_resource class: Scheduling

  skip_authorization_check
  before_filter :authorize_read_report


  def total_duration
    @schedulings.reject(&:previous_day).sum { |s| s.decimal_duration }
  end
  helper_method :total_duration

  protected

  def authorize_read_report
    authorize! :read_report, current_account
  end
end

