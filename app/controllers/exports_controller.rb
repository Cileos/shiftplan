class ExportsController < InheritedResources::Base
  load_and_authorize_resource class: IcalExport

  def create
    create! { profile_export_path }
  end

  def destroy
    destroy! { profile_export_path }
  end

  protected

  def resource
    @ical_export ||= IcalExport.new(current_user)
  end

  def build_resource
    resource
  end

end
