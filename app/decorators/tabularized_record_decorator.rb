class TabularizedRecordDecorator < ApplicationDecorator
  delegate_all

  def respond
    unless errors.empty?
      prepend_errors_for(record)
    else
      clear_modal
      update_records
      highlight_record
      update_flash
    end
  end

  private

    def record
      model
    end

    def selector_for(name, record=nil, extra=nil)
      case name
      when :records
        'div#records'
      when :record
        "tr#record_#{record.id}"
      else
        super
      end
    end

    def update_records
      select(:records).refresh_html records_table
    end

    def records_table
      h.render("#{pluralized_resource_name}/table", records: records)
    end

    def records
      base.public_send(pluralized_resource_name).order(:name)
    end

    def base
      if record.respond_to?(:account)
        h.current_account
      elsif resource.respond_to?(:organization)
        h.current_organization
      else
        raise "could not find base for resource"
      end
    end

    def highlight_record
      select(:record, record).effect('highlight', {}, 3000)
    end

    def resource_name
      @resource_name ||= model.class.name.underscore
    end

    def pluralized_resource_name
      resource_name.pluralize
    end
end
