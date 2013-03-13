class InvitationDecorator < TabularizedRecordDecorator

  private

    def records
      h.current_organization.employees
    end

    def records_css_class
      'employees'
    end

    def table_partial_name
      'employees/table'
    end
end
